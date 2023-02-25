//
//  MarketAreas+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 11/11/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class MarketArea: NSManagedObject { }

// MARK: - PROPERTIES
extension MarketArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarketArea> {
        return NSFetchRequest<MarketArea>(entityName: "MarketArea")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var area: String?
    @NSManaged public var companies: NSSet?
}

// MARK: - GENERATED ACCESSORS FOR COMPANIES
extension MarketArea {

    @objc(addCompaniesObject:)
    @NSManaged public func addToCompanies(_ value: Company)

    @objc(removeCompaniesObject:)
    @NSManaged public func removeFromCompanies(_ value: Company)

    @objc(addCompanies:)
    @NSManaged public func addToCompanies(_ values: NSSet)

    @objc(removeCompanies:)
    @NSManaged public func removeFromCompanies(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension MarketArea : Identifiable { }
