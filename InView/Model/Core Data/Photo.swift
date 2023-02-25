//
//  Photo+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 10/10/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Photo: NSManagedObject { }

// MARK: - PROPERTIES
extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photo: String?
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var name: String?
    @NSManaged public var project: Project?
}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Photo : Identifiable { }
