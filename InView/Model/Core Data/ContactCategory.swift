//
//  CustomerCategories+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 11/11/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class ContactCategory: NSManagedObject { }

// MARK: - PROPERTIES
extension ContactCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactCategory> {
        return NSFetchRequest<ContactCategory>(entityName: "ContactCategory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var category: String?
    @NSManaged public var contacts: NSSet?

}

// MARK: - GENERATED ACCESSORS FOR CONTACTS
extension ContactCategory {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension ContactCategory : Identifiable { }
