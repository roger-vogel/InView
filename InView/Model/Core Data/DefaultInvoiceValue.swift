//
//  Invoice+CoreDataProperties.swift
//  InView-2
//
//  Created by Roger Vogel on 2/24/23.
//
//

import Foundation
import CoreData

public class DefaultInvoiceValue: NSManagedObject {

}

extension DefaultInvoiceValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultInvoiceValue> {
        return NSFetchRequest<DefaultInvoiceValue>(entityName: "DefaultInvoiceValue")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var city: String?
    @NSManaged public var defaultDiscount: Double
    @NSManaged public var email: String?
    @NSManaged public var hasLogo: Bool
    @NSManaged public var logo: String?
    @NSManaged public var market: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var primaryStreet: String?
    @NSManaged public var subStreet: String?
    @NSManaged public var state: String?
    @NSManaged public var tax: Double
    @NSManaged public var terms: String?
    @NSManaged public var website: String?
    @NSManaged public var emailSignature: String?
}

extension DefaultInvoiceValue : Identifiable {

}
