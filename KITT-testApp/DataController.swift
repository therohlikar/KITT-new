//
//  DataController.swift
//  KITT
//
//  Created by Radek Jeník on 2/24/23.
//

//import SwiftUI
import CoreData
import Foundation

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
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    /**
     
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
     
    */
    func save(){
        do {
            try context.save()
        }catch let error{
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
}
