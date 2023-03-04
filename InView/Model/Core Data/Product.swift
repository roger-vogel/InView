//
//  Product+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 10/14/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Product: NSManagedObject {

}

// MARK: - PROPERTIES
extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var category: ProductCategory?
    @NSManaged public var productDescription: String?
    @NSManaged public var productID: String?
    @NSManaged public var unitDescription: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var unitPrice: Double
    @NSManaged public var quantity: Int32
    @NSManaged public var invoiced: Int16
    @NSManaged public var project: Project?
}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Product : Identifiable {

}
