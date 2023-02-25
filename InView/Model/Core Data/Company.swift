//
//  Companies+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Company: NSManagedObject { }

// MARK: - PROPERTIES
extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var appId: String?
    @NSManaged public var city: String?
    @NSManaged public var hasPhoto: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var photo: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var primaryStreet: String?
    @NSManaged public var quickNotes: String?
    @NSManaged public var state: String?
    @NSManaged public var subStreet: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var website: String?
    @NSManaged public var category: CompanyCategory?
    @NSManaged public var market: MarketArea?
    @NSManaged public var priorYear: Int32
    @NSManaged public var manualEntry: Int32
    @NSManaged public var activities: NSSet?
    @NSManaged public var employees: NSSet?
    @NSManaged public var logEntries: NSSet?
    @NSManaged public var projects: NSSet?
    @NSManaged public var memberOf: NSSet?

}

// MARK: - GENERATED ACCESSORS FOR ACTIVITIES
extension Company {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

// MARK: - GENERATED ACCESSSORS FOR EMPLOYEES
extension Company {

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Contact)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Contact)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR LOG ENTRIES
extension Company {

    @objc(addLogEntriesObject:)
    @NSManaged public func addToLogEntries(_ value: LogEntry)

    @objc(removeLogEntriesObject:)
    @NSManaged public func removeFromLogEntries(_ value: LogEntry)

    @objc(addLogEntries:)
    @NSManaged public func addToLogEntries(_ values: NSSet)

    @objc(removeLogEntries:)
    @NSManaged public func removeFromLogEntries(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR PROJECTS
extension Company {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR MEMBERS
extension Company {

    @objc(addMemberOfObject:)
    @NSManaged public func addToMemberOf(_ value: Group)

    @objc(removeMemberOfObject:)
    @NSManaged public func removeFromMemberOf(_ value: Group)

    @objc(addMemberOf:)
    @NSManaged public func addToMemberOf(_ values: NSSet)

    @objc(removeMemberOf:)
    @NSManaged public func removeFromMemberOf(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Company : Identifiable { }
