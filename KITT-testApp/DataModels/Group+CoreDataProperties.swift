//
//  Group+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var offense: NSSet?
    
    public var wrappedTitle: String { title ?? "" }
    public var offenseArray: [Offense] {
        let set = offense as? Set<Offense> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
}

// MARK: Generated accessors for offense
extension Group {

    @objc(addOffenseObject:)
    @NSManaged public func addToOffense(_ value: Offense)

    @objc(removeOffenseObject:)
    @NSManaged public func removeFromOffense(_ value: Offense)

    @objc(addOffense:)
    @NSManaged public func addToOffense(_ values: NSSet)

    @objc(removeOffense:)
    @NSManaged public func removeFromOffense(_ values: NSSet)

}

extension Group : Identifiable {

}
