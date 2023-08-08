//
//  DataController.swift
//  KITT
//
//  Created by Radek Jeník on 2/24/23.
//

//import SwiftUI
import CoreData
import Foundation

enum DataException: Error{
    case networkNotConnected
    case emptyLocalStorage
}

/**
 Class runs its own instances, static, that holds and manages CoreData structure and data itself.
 */
class DataController: ObservableObject{
    lazy var context: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    let container = NSPersistentContainer(name: "KittDataModel")
    
    init () {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    /**
     Updates local content with downloaded remote content if there is a new version to be downloaded.
     
     Condition can be ignored with parameter 'forceUpdate'. It is executed on its own when user opens the app for the first time and also on a specific action (f.e. button action). Checks remote version and if there is a new version to be downloaded, downloads that version, converts downloaded .json file into Models (ItemModel and VersionModel), updates local storage (coredata context) and saves new version as a current one.
     
     While doing so the app is not functional - disabled - for user. Terminating an app will stop the process but it should not damage already downloaded content.
  - Parameters:
         - forceUpdate: Boolean that forces update ignoring all conditions - downloads content no matter what version device has
  - Throws: `DataController.networkNotconnected` if device is not connected to a network
     */
    func prepareData(_ forceUpdate: Bool = false) async throws {
        if !NetworkController.network.connected {
            throw DataException.networkNotConnected
        }
        do {
            if try await !VersionController.controller.isDataUpToDate() || forceUpdate {
                let _ = try await VersionController.controller.getVersionNews(self)
                
                let itemArray = try await JsonDataController.controller.getRemoteContent(self)
                try await VersionController.controller.setCurrentVersionAsRemoteVersion()
                do {
                    
                    let _ = try await self.clearItemDuplicates(items: itemArray)
                }
                catch DataException.emptyLocalStorage{
                    print("There is nothing to remove on a local storage")
                }catch{
                    print(error)
                }
            }
        }catch {
            print(error)
        }
        
    }
    /**
        Removes unnecessary duplicates in the local storage, is used after the content data are prepared - either on .task or forced via button action.

        It's a tool more like a function. Goes through all ContentItem types in local storage and converted remote json and looks for items, that do not exist in the remote version and removes them locally. Basically if we do not want to have any item and push its removal to devices, just remove them remotely. Same logic works if we change ID on remote storage.
     - Parameters:
            - items: an array of type ItemModel
     - Returns: count of removed duplicates (removedCount - Integer)
     - Throws: `DataController.emptyLocalStorage` if there is no local database with ContentItem
     */
    func clearItemDuplicates(items: [ItemModel]) async throws -> Int {
        var removedCount = 0
        if !items.isEmpty {
            try await self.context.perform {
                let request = ContentItem.fetchRequest()
                if let contentItems = try? self.context.fetch(request) {
                    for item in contentItems {
                        if !items.contains(where: {$0.id == item.wrappedId}){
                            self.context.delete(item)
                            removedCount = removedCount + 1
                        }
                    }
                }else{
                    throw DataException.emptyLocalStorage
                }
            }
        }
        return removedCount
    }
    /**
     Saves asynchronously Item locally with parameter's values and creates Groups if the one as a value does not exist.
     
     It also saves changes made to the core data context.
     
     - Parameters:
        - item: ItemModel - holds values
     */
    func updateItemContent(_ item: ItemModel) async {
        await self.context.perform {
            var currentFavorited = false
            var currentNote = ""
            
            let request = ContentItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id!)
            request.fetchLimit = 1
            
            if let itemExists = try? self.context.fetch(request).first{
                currentFavorited = itemExists.favorited
                currentNote = itemExists.wrappedNote
            }
            
            //prepare group
            let group = Group(context: self.context)
            group.title = item.group
            
            let new = ContentItem(context: self.context)
            new.id = item.id
            
            new.group = group
            var subgroupName = item.subgroup ?? "NEZAŘAZENO"
            if subgroupName.isEmpty {
                subgroupName = "NEZAŘAZENO"
            }
            new.subgroup = subgroupName
            new.type = item.type
            new.title = item.title
            new.sanctions = item.sanctions
            new.links = item.links
            new.keywords = item.keywords
            new.warning = item.warning
            new.miranda = item.miranda
            new.content = item.content
            new.example = item.example
            
            new.note = currentNote
            new.favorited = currentFavorited
            
            self.save()
        }
        
    }
    /**
     Saves asynchronously Version locally with parameter's values.
     
     It also saves changes made to the core data context.
     
     - Parameters:
        - item: VersionModel - holds values
     */
    func updateVersionNews(_ item: VersionModel) async{
        var read = false
        
        let request = Version.fetchRequest()
        request.predicate = NSPredicate(format: "version == %@", item.version)
        request.fetchLimit = 1
        
        if let versionExists = try? context.fetch(request).first{
            read = versionExists.read
        }
        
        let version = Version(context: self.context)
        version.version = item.version
        version.content = item.news.joined(separator: "\n")
        version.read = read
        
        self.save()
    }
    /**
            Saves local storage (context).
    */
    func save(){
        do {
            try context.save()
        }catch let error{
            print("Error saving Core Data. \(error)")
        }
    }
    /**
     Removes all tables currently saved in the database locally
     
     Note to myself: rework
     - Returns: Boolean if process was success or not
     */
    func removeAll() -> Bool {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ContentItem")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Version")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Group")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error)")
        }
        
        return true
    }
}
