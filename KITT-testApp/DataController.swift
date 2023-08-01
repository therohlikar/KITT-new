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
    
    /**
     Tries to save current NSManagedObjectContext (CoreData type) and its changes. Or catches an error.
     
     - Throws: error.localizedDescription in print()
     */
    func save(){
        do {
            try context.save()
        }catch let error{
            print("Error saving Core Data. \(error.localizedDescription)")
        }
        
    }
    
    
}
