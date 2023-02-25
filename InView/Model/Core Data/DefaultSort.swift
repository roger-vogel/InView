//
//  DefaultSort+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 11/18/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class DefaultSort: NSManagedObject { }

// MARK: - PROPERTIES
extension DefaultSort {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultSort> {
        
        return NSFetchRequest<DefaultSort>(entityName: "DefaultSort")
    }

    @NSManaged public var forPeople: Int16
    @NSManaged public var forCompany: Int16
}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension DefaultSort : Identifiable { }
