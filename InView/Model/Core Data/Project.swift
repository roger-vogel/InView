//
//  Project+CoreDataClass.swift
//  InView
//
//  Created by Roger Vogel on 10/6/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Project: NSManagedObject { }

// MARK: - PROPERTIES
extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
       
        return NSFetchRequest<Project>(entityName: "Project")
    }
    
    @NSManaged public var completionDate: Date?
    @NSManaged public var market: String?
    @NSManaged public var name: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var appId: String?
    @NSManaged public var city: String?
    @NSManaged public var id: UUID?
    @NSManaged public var primaryStreet: String?
    @NSManaged public var stage: String?
    @NSManaged public var start: Int64
    @NSManaged public var state: String?
    @NSManaged public var status: String?
    @NSManaged public var subStreet: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var companies: NSSet?
    @NSManaged public var documents: NSSet?
    @NSManaged public var logEntries: NSSet?
    @NSManaged public var photos: NSSet?
    @NSManaged public var products: NSSet?
    @NSManaged public var team: NSSet?
    @NSManaged public var activities: NSSet?

}

// MARK: - GENERATED ACCESSORS FOR COMPANIES
extension Project {

    @objc(addCompaniesObject:)
    @NSManaged public func addToCompanies(_ value: Company)

    @objc(removeCompaniesObject:)
    @NSManaged public func removeFromCompanies(_ value: Company)

    @objc(addCompanies:)
    @NSManaged public func addToCompanies(_ values: NSSet)

    @objc(removeCompanies:)
    @NSManaged public func removeFromCompanies(_ values: NSSet)

}

// MARK: GENERATED ACCESSORS FOR DOCUMENTS
extension Project {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: Document)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: Document)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR LOG ENTRIES
extension Project {

    @objc(addLogEntriesObject:)
    @NSManaged public func addToLogEntries(_ value: LogEntry)

    @objc(removeLogEntriesObject:)
    @NSManaged public func removeFromLogEntries(_ value: LogEntry)

    @objc(addLogEntries:)
    @NSManaged public func addToLogEntries(_ values: NSSet)

    @objc(removeLogEntries:)
    @NSManaged public func removeFromLogEntries(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR PHOTOS
extension Project {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR PRODUCTS
extension Project {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR TEAM
extension Project {

    @objc(addTeamObject:)
    @NSManaged public func addToTeam(_ value: Contact)

    @objc(removeTeamObject:)
    @NSManaged public func removeFromTeam(_ value: Contact)

    @objc(addTeam:)
    @NSManaged public func addToTeam(_ values: NSSet)

    @objc(removeTeam:)
    @NSManaged public func removeFromTeam(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR ACTIVITIES
extension Project {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Project : Identifiable { }
