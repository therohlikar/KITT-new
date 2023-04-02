//
//  Group+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/29/23.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var crime: NSSet?
    @NSManaged public var lawextract: NSSet?
    @NSManaged public var offense: NSSet?
    @NSManaged public var contentitem: NSSet?
    public var wrappedTitle: String { title ?? "" }
    public var offenseArray: [Offense] {
        let set = offense as? Set<Offense> ?? []
        return set.sorted {
           $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    public var crimeArray: [Crime] {
       let set = crime as? Set<Crime> ?? []
       return set.sorted {
           $0.wrappedTitle < $1.wrappedTitle
       }
    }
    public var leArray: [LawExtract] {
        let set = lawextract as? Set<LawExtract> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    public var ciArray: [ContentItem] {
        let set = contentitem as? Set<ContentItem> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
}

// MARK: Generated accessors for crime
extension Group {

    @objc(addCrimeObject:)
    @NSManaged public func addToCrime(_ value: Crime)

    @objc(removeCrimeObject:)
    @NSManaged public func removeFromCrime(_ value: Crime)

    @objc(addCrime:)
    @NSManaged public func addToCrime(_ values: NSSet)

    @objc(removeCrime:)
    @NSManaged public func removeFromCrime(_ values: NSSet)

}

// MARK: Generated accessors for lawextract
extension Group {

    @objc(addLawextractObject:)
    @NSManaged public func addToLawextract(_ value: LawExtract)

    @objc(removeLawextractObject:)
    @NSManaged public func removeFromLawextract(_ value: LawExtract)

    @objc(addLawextract:)
    @NSManaged public func addToLawextract(_ values: NSSet)

    @objc(removeLawextract:)
    @NSManaged public func removeFromLawextract(_ values: NSSet)

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

// MARK: Generated accessors for contentitem
extension Group {

    @objc(addContentitemObject:)
    @NSManaged public func addToContentitem(_ value: ContentItem)

    @objc(removeContentitemObject:)
    @NSManaged public func removeFromContentitem(_ value: ContentItem)

    @objc(addContentitem:)
    @NSManaged public func addToContentitem(_ values: NSSet)

    @objc(removeContentitem:)
    @NSManaged public func removeFromContentitem(_ values: NSSet)

}

extension Group : Identifiable {

}
