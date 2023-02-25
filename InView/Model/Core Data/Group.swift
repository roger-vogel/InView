//
//  Groups+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class Group: NSManagedObject { }

// MARK: - PROPERTIES
extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var appId: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isDivider: Bool
    @NSManaged public var name: String?
    @NSManaged public var sortOrder: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var peopleMembers: NSSet?
    @NSManaged public var companyMembers: NSSet?
}

// MARK: - GENERATED ACCESSORS FOR PEOPLE MEMBERS
extension Group {

    @objc(addPeopleMembersObject:)
    @NSManaged public func addToPeopleMembers(_ value: Contact)

    @objc(removePeopleMembersObject:)
    @NSManaged public func removeFromPeopleMembers(_ value: Contact)

    @objc(addPeopleMembers:)
    @NSManaged public func addToPeopleMembers(_ values: NSSet)

    @objc(removePeopleMembers:)
    @NSManaged public func removeFromPeopleMembers(_ values: NSSet)

}

// MARK: - GENERATED ACCESSORS FOR COMPANY MEMBERS
extension Group {

    @objc(addCompanyMembersObject:)
    @NSManaged public func addToCompanyMembers(_ value: Company)

    @objc(removeCompanyMembersObject:)
    @NSManaged public func removeFromCompanyMembers(_ value: Company)

    @objc(addCompanyMembers:)
    @NSManaged public func addToCompanyMembers(_ values: NSSet)

    @objc(removeCompanyMembers:)
    @NSManaged public func removeFromCompanyMembers(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension Group : Identifiable { }
