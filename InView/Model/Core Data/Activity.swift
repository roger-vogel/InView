//
//  Activity+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 1/3/23.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Activity: NSManagedObject { }

// MARK: - PROPERTIES
extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var activityDescription: String?
    @NSManaged public var appId: String?
    @NSManaged public var daysOfMonth: String?
    @NSManaged public var daysOfWeek: String?
    @NSManaged public var activityDate: Date?
    @NSManaged public var activityEndTime: Date?
    @NSManaged public var activityStartTime: Date?
    @NSManaged public var frequency: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isEvent: Bool
    @NSManaged public var isTask: Bool
    @NSManaged public var isAllDay: Bool
    @NSManaged public var location: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var companies: NSSet?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var projects: NSSet?
}

// MARK: - GENERATED ACCESSORS FOR COMPANIES
extension Activity {

    @objc(addCompaniesObject:)
    @NSManaged public func addToCompanies(_ value: Company)

    @objc(removeCompaniesObject:)
    @NSManaged public func removeFromCompanies(_ value: Company)

    @objc(addCompanies:)
    @NSManaged public func addToCompanies(_ values: NSSet)

    @objc(removeCompanies:)
    @NSManaged public func removeFromCompanies(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR CONTACTS
extension Activity {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR PROJECTS
extension Activity {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Activity : Identifiable { }
