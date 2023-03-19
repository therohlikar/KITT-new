//
//  Crime+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//
//

import Foundation
import CoreData


extension Crime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Crime> {
        return NSFetchRequest<Crime>(entityName: "Crime")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var paragraph: String?
    @NSManaged public var warning: String?
    @NSManaged public var miranda: String?
    @NSManaged public var crimeExample: String?
    @NSManaged public var note: String?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var group: NSSet?
    
    public var wrappedTitle: String { title ?? "" }
    public var wrappedContent: String { content ?? "" }
    public var wrappedParagraph: String { paragraph ?? "" }
    public var wrappedCrimeExample: String { crimeExample ?? "" }
    public var wrappedWarning: String { warning ?? "" }
    public var wrappedMiranda: String { miranda ?? "" }
    public var wrappedNote: String { note ?? "" }
    public var groupArray: [Group] {
        let set = group as? Set<Group> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    public var paragraphModel: ParagraphModel {
        let splitParagraph = wrappedParagraph.components(separatedBy: "-")
        
        return ParagraphModel(lawNumber: splitParagraph.indices.contains(0) ? splitParagraph[0] : "",
                              lawYear: splitParagraph.indices.contains(1) ? splitParagraph[1] : "",
                              paragraphNumber: splitParagraph.indices.contains(2) ? splitParagraph[2] : "",
                              paragraphSection: splitParagraph.indices.contains(3) ? splitParagraph[3] : "",
                              paragraphLetter: splitParagraph.indices.contains(4) ? splitParagraph[4] : "",
                              paragraphPoint: splitParagraph.indices.contains(5) ? splitParagraph[5] : ""
        )
    }
}

// MARK: Generated accessors for group
extension Crime {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: Group)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: Group)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension Crime : Identifiable {

}
