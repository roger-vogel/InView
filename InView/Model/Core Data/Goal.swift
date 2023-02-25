//
//  Goal+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 2/12/23.
//
//

import Foundation
import CoreData

public class Goal: NSManagedObject { }

extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var month: Int16
    @NSManaged public var monthToDate: Int32
    @NSManaged public var goal: Int32
    @NSManaged public var priorYear: Int32
}

extension Goal : Identifiable { }
