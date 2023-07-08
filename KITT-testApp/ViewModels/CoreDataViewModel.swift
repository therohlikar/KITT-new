//
//  CoreDataViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/8/23.
//

import Foundation
import CoreData

class CoreDataViewModel:ObservableObject {
    
    let manager: DataController

    init(manager: DataController = .instance) {
        self.manager = manager
    }
    
    func getGroups() -> [Group] {
            let groupsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")

            do {
                let groupsFetch = try manager.container.viewContext.fetch(groupsFetch) as! [Group]
                
                return groupsFetch
            } catch {
                fatalError("Failed to fetch groups: \(error)")
            }
        }
}
