//
//  Report+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 2/12/23.
//
//

import Foundation
import CoreData


public class Report: NSManagedObject { }

extension Report {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Report> {
        return NSFetchRequest<Report>(entityName: "Report")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var reportType: Int16
    @NSManaged public var isManual: Bool
    @NSManaged public var funnelEntries: String?
    @NSManaged public var manualSales: NSSet?
}

extension Report : Identifiable { }
