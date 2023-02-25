//
//  CompanyCategory+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 12/26/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class CompanyCategory: NSManagedObject { }

// MARK: - PROPERTIES
extension CompanyCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyCategory> {
        return NSFetchRequest<CompanyCategory>(entityName: "CompanyCategory")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var companies: NSSet?
}

// MARK: - GENERATED ACCESSORS FOR COMPANIES
extension CompanyCategory {

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
extension CompanyCategory : Identifiable { }
