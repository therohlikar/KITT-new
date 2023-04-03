//
//  ContentItem+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/29/23.
//
//

import Foundation
import CoreData

extension ContentItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentItem> {
        return NSFetchRequest<ContentItem>(entityName: "ContentItem")
    }

    @NSManaged public var group: Group?
    
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var subgroup: String?
    @NSManaged public var content: String?
    @NSManaged public var sanctions: String?
    @NSManaged public var miranda: String?
    @NSManaged public var links: String?
    @NSManaged public var warning: String?
    @NSManaged public var keywords: String?
    @NSManaged public var favorited: Bool
    @NSManaged public var note: String?
    @NSManaged public var example: String?

    public var wrappedTitle: String { title ?? "" }
    public var wrappedType: String { type ?? "" }
    public var wrappedSubgroup: String { subgroup ?? "" }
    public var wrappedContent: String { content ?? "" }
    public var wrappedSanctions: String { sanctions ?? "" }
    public var wrappedMiranda: String { miranda ?? "" }
    public var wrappedLinks: String { links ?? "" }
    public var wrappedWarning: String { warning ?? "" }
    public var wrappedKeywords: String { keywords ?? "" }
    public var wrappedNote: String { note ?? "" }
    public var wrappedExample: String { example ?? "" }
    
    var sanctionList: [SanctionModel] {
        if !wrappedSanctions.isEmpty {
            if let decodedResponse = try? JSONDecoder().decode([SanctionModel].self, from: Data(wrappedSanctions.utf8)){
                return decodedResponse
            }else{
                fatalError("SANCTIONLIST - Json could not be decoded")
            }
        }
        return []
    }
    
    var linkList: [LinkModel] {
        if !wrappedLinks.isEmpty {
            if let decodedResponse = try? JSONDecoder().decode([LinkModel].self, from: Data(wrappedLinks.utf8)){
                return decodedResponse
            }else{
                fatalError("LINKLIST - Json could not be decoded")
            }
        }
        return []
    }
    
    var contentList: [ContentModel] {
        if !wrappedLinks.isEmpty {
            if let decodedResponse = try? JSONDecoder().decode([ContentModel].self, from: Data(wrappedContent.utf8)){
                return decodedResponse
            }else{
                fatalError("CONTENTLIST - Json could not be decoded")
            }
        }
        return []
    }
}

extension ContentItem : Identifiable {

}
