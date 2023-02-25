//
//  Contacts+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Contact: NSManagedObject { }

// MARK: - PROPERTIES
extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var appId: String?
    @NSManaged public var city: String?
    @NSManaged public var customEmail: String?
    @NSManaged public var customPhone: String?
    @NSManaged public var firstName: String?
    @NSManaged public var hasPhoto: Bool
    @NSManaged public var homePhone: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var mobilePhone: String?
    @NSManaged public var otherEmail: String?
    @NSManaged public var personalEmail: String?
    @NSManaged public var photo: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var primaryStreet: String?
    @NSManaged public var quickNotes: String?
    @NSManaged public var state: String?
    @NSManaged public var subStreet: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var workEmail: String?
    @NSManaged public var workPhone: String?
    @NSManaged public var activities: NSSet?
    @NSManaged public var category: ContactCategory?
    @NSManaged public var company: Company?
    @NSManaged public var logEntries: NSSet?
    @NSManaged public var memberOf: NSSet?
    @NSManaged public var projects: NSSet?

}

// MARK: - GENERATED ACCESSORS FOR ACTIVITIES
extension Contact {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR LOG ENTRIES
extension Contact {

    @objc(addLogEntriesObject:)
    @NSManaged public func addToLogEntries(_ value: LogEntry)

    @objc(removeLogEntriesObject:)
    @NSManaged public func removeFromLogEntries(_ value: LogEntry)

    @objc(addLogEntries:)
    @NSManaged public func addToLogEntries(_ values: NSSet)

    @objc(removeLogEntries:)
    @NSManaged public func removeFromLogEntries(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR MEMBER OF
extension Contact {

    @objc(addMemberOfObject:)
    @NSManaged public func addToMemberOf(_ value: Group)

    @objc(removeMemberOfObject:)
    @NSManaged public func removeFromMemberOf(_ value: Group)

    @objc(addMemberOf:)
    @NSManaged public func addToMemberOf(_ values: NSSet)

    @objc(removeMemberOf:)
    @NSManaged public func removeFromMemberOf(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR PROJECTS
extension Contact {

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
extension Contact : Identifiable { }
