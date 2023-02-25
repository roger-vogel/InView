//
//  Documents+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 10/10/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Document: NSManagedObject { }

// MARK: - PROPERTIES
extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        
        return NSFetchRequest<Document>(entityName: "Documents")
    }

    @NSManaged public var content: String?
    @NSManaged public var fileExtension: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var url: String?
    @NSManaged public var project: Project?
}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Document : Identifiable { }
