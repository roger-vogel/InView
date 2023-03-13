//
//  Product+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 10/14/22.
//
//

import Foundation
import CoreData

public class Product: NSManagedObject { }

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var invoiced: Int16
    @NSManaged public var productDescription: String?
    @NSManaged public var productID: String?
    @NSManaged public var quantity: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var unitDescription: String?
    @NSManaged public var unitPrice: Double
    @NSManaged public var category: ProductCategory?
    @NSManaged public var projects: NSSet?
}

// MARK: Generated accessors for project
extension Product {

    @objc(addProjectObject:)
    @NSManaged public func addToProject(_ value: Project)

    @objc(removeProjectObject:)
    @NSManaged public func removeFromProject(_ value: Project)

    @objc(addProject:)
    @NSManaged public func addToProject(_ values: NSSet)

    @objc(removeProject:)
    @NSManaged public func removeFromProject(_ values: NSSet)

}

extension Product : Identifiable { }




