//
//  ProductCategories+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 11/11/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class ProductCategory: NSManagedObject { }

// MARK: - PROPERTIES
extension ProductCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCategory> {
        return NSFetchRequest<ProductCategory>(entityName: "ProductCategory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var category: String?
    @NSManaged public var priorYear: Int32
    @NSManaged public var manualEntry: Int32
    @NSManaged public var funnelEntry: Int32
    @NSManaged public var products: NSSet?
}

// MARK: - GENERATED ACCESSORS FOR PROJECTS
extension ProductCategory {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension ProductCategory : Identifiable { }
