//
//  Version+CoreDataProperties.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//
//

import Foundation
import CoreData


extension Version {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Version> {
        return NSFetchRequest<Version>(entityName: "Version")
    }

    @NSManaged public var version: String?
    @NSManaged public var content: String?

    public var wrappedVersion: String { version ?? "" }
    public var wrappedContent: String { content ?? "" }
}

extension Version : Identifiable {

}
