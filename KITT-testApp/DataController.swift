//
//  DataController.swift
//  KITT
//
//  Created by Radek Jeník on 2/24/23.
//

//import SwiftUI
import CoreData
import Foundation

class DataController: ObservableObject{
    //@AppStorage("currentVersion") private var currentVersion: String = "0.0.0"
    let container = NSPersistentContainer(name: "KittDataModel")
        
    init () {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func trySave(){
        try? self.container.viewContext.save()
    }
//
//    func prepareData(networkController: NetworkController) async -> Bool {
//        if !networkController.connected {
//            return true
//        }else{
//            let newestVersion = await VersionController().getNewestVersion()
//
//            if newestVersion <= currentVersion {
//                return true
//            }
//            else {
//                if let versionArray = await VersionController().loadVersionUpdates() {
//                    var read:Bool = false
//                    for item in versionArray {
//                        read = false
//                        if let versionExists = versions.first(where: {$0.version == item.version }){
//                            read = versionExists.read
//                        }
//
//                        let version = Version(context: self.container.viewContext)
//                        version.version = item.version
//                        version.content = item.news.joined(separator: "\n")
//                        version.read = read
//                    }
//                }
//
//                let jsonController = JsonDataController()
//                if let offenseArray: Array<OffenseModel> = await jsonController.downloadJsonData(.offense) as? Array<OffenseModel> {
//                    var note: String = ""
//                    var isFavorited: Bool = false
//                    var customId: String? = ""
//
//                    for item in offenseArray {
//                        note = item.note
//                        isFavorited = false
//                        customId = item.id == nil ? item.paragraph : item.id
//
//                        if let existingOffense = offenses.first(where: {$0.id == customId}){
//                            note = existingOffense.wrappedNote
//                            isFavorited = existingOffense.isFavorited
//
//                            existingOffense.group = nil
//
//                            self.container.viewContext.delete(existingOffense)
//                        }
//
//                        let newOffense = Offense(context: self.container.viewContext)
//                        newOffense.id = customId
//                        // id is same as paragraph, which is unique all the time
//                        //loop through groups, if any, and create or invite them in
//                        for group in item.groups{
//                            let newGroup:Group = Group(context: self.container.viewContext)
//                            newGroup.title = group
//                            newOffense.addToGroup(newGroup)
//                        }
//                        newOffense.title = item.title
//                        newOffense.content = item.content
//                        newOffense.paragraph = item.paragraph
//                        newOffense.violationParagraph = item.violationParagraph
//                        newOffense.resolveOptions = item.resolveOptions
//                        newOffense.offenseScore = Int16(item.offenseScore)
//                        newOffense.isOffenseTracked = item.isOffenseTracked
//                        newOffense.fineExample = item.fineExample
//                        newOffense.miranda = item.miranda
//                        newOffense.warning = item.warning
//
//                        newOffense.note = note
//                        newOffense.isFavorited = isFavorited
//                    }
//
//                    // list through all offenses and if it is NOT on the remote by its id, remove test
//                    for duplicate in offenses {
//                        if !offenseArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
//                            self.container.viewContext.delete(duplicate)
//                        }
//                    }
//                }
//                if let crimeArray = await jsonController.downloadJsonData(.crime) as? Array<CrimeModel> {
//                    var note: String = ""
//                    var isFavorited: Bool = false
//                    for item in crimeArray {
//                        note = item.note
//                        isFavorited = false
//
//                        if let existingCrime = crimes.first(where: {$0.id == item.paragraph}){
//                            note = existingCrime.wrappedNote
//                            isFavorited = existingCrime.isFavorited
//
//                            existingCrime.group = nil
//
//                            self.container.viewContext.delete(existingCrime)
//                        }
//
//                        let newCrime = Crime(context: self.container.viewContext)
//                        newCrime.id = item.paragraph
//                        // id is same as paragraph, which is unique all the time
//                        //loop through groups, if any, and create or invite them in
//                        for group in item.groups{
//                            let newGroup:Group = Group(context: self.container.viewContext)
//                            newGroup.title = group
//                            newCrime.addToGroup(newGroup)
//                        }
//                        newCrime.title = item.title
//                        newCrime.content = item.content
//                        newCrime.paragraph = item.paragraph
//                        newCrime.crimeExample = item.crimeExample
//                        newCrime.miranda = item.miranda
//                        newCrime.warning = item.warning
//
//                        newCrime.note = note
//                        newCrime.isFavorited = isFavorited
//                    }
//
//                    for duplicate in crimes {
//                        if !crimeArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
//                            self.container.viewContext.delete(duplicate)
//                        }
//                    }
//                }
//                if let leArray = await jsonController.downloadJsonData(.lawextract) as? Array<LawExtractModel> {
//                    var note: String = ""
//                    var isFavorited: Bool = false
//                    for item in leArray {
//                        note = item.note
//                        isFavorited = false
//
//                        if let existingLe = lawextracts.first(where: {$0.id == item.paragraph}){
//                            note = existingLe.wrappedNote
//                            isFavorited = existingLe.isFavorited
//
//                            existingLe.group = nil
//
//                            self.container.viewContext.delete(existingLe)
//                        }
//
//                        let newLe = LawExtract(context: self.container.viewContext)
//                        newLe.id = item.paragraph
//                        // id is same as paragraph, which is unique all the time
//                        //loop through groups, if any, and create or invite them in
//                        for group in item.groups{
//                            let newGroup:Group = Group(context: self.container.viewContext)
//                            newGroup.title = group
//                            newLe.addToGroup(newGroup)
//                        }
//                        newLe.title = item.title
//                        newLe.content = item.content
//                        newLe.paragraph = item.paragraph
//                        newLe.miranda = item.miranda
//                        newLe.warning = item.warning
//
//                        newLe.note = note
//                        newLe.isFavorited = isFavorited
//                    }
//
//                    for duplicate in lawextracts {
//                        if !leArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
//                            self.container.viewContext.delete(duplicate)
//                        }
//                    }
//                }
//
//                //clear groups
//                for group in groups {
//                    if group.offenseArray.isEmpty && group.crimeArray.isEmpty && group.leArray.isEmpty {
//                        self.container.viewContext.delete(group)
//                    }
//                }
//
//                self.trySave()
//
//                currentVersion = newestVersion
//
//                if !firstOpen {
//                    firstOpen = true
//                }
//
//                return true
//            }
//        }
//    }
}
