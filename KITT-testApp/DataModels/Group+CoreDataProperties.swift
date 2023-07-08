//
//  Group+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/29/23.
//
//

import Foundation
import CoreData
import SwiftUI


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var contentitem: NSSet?
    public var wrappedTitle: String { title ?? "" }

    public var ciArray: [ContentItem] {
        let set = contentitem as? Set<ContentItem> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    public var groupType: String {
        if let tempItem = contentitem?.anyObject() {
            let item:ContentItem = tempItem as! ContentItem
            return item.wrappedType
        }
        return ""
    }
    
    var typeToColor: Color {
        switch(self.groupType){
            case "offense": return Color(#colorLiteral(red: 0, green: 0.431452632, blue: 0.77961272, alpha: 0.5))
            case "crime": return Color(#colorLiteral(red: 0.7391448617, green: 0, blue: 0.02082144469, alpha: 0.5))
            case "law": return Color(#colorLiteral(red: 0.9611360431, green: 0.5784681439, blue: 0, alpha: 0.5))
            default: return Color(#colorLiteral(red: 0.7754455209, green: 0.7807555795, blue: 0.7612403035, alpha: 0.5))
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
