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
    
    static let instance = DataController()
    
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
    
    func save(){
        do {
            try context.save()
        }catch let error{
            print("Error saving Core Data. \(error.localizedDescription)")
        }
        
    }
    
    
}
