//
//  Invoice+CoreDataProperties.swift
//  InView-2
//
//  Created by Roger Vogel on 2/24/23.
//
//

import Foundation
import CoreData

public class Invoice: NSManagedObject {

}

extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var city: String?
    @NSManaged public var market: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var state: String?
    @NSManaged public var primaryStreet: String?
    @NSManaged public var subStreet: String?
    @NSManaged public var website: String?
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var hasLogo: Bool
    @NSManaged public var logo: String?
    @NSManaged public var tax: Double

}

extension Invoice : Identifiable {

}
