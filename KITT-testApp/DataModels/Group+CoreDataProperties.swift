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

    public var ciArray: [ContentItem] {
        let set = contentitem as? Set<ContentItem> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
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
