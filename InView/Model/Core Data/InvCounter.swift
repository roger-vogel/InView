//
//  InvCounter+CoreDataProperties.swift
//  InView-2
//
//  Created by Roger Vogel on 3/4/23.
//
//

import Foundation
import CoreData

public class InvCounter: NSManagedObject { }

extension InvCounter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InvCounter> {
        return NSFetchRequest<InvCounter>(entityName: "InvCounter")
    }

    @NSManaged public var countValue: Int32
}

extension InvCounter : Identifiable { }
