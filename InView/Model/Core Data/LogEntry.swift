//
//  LogEntries+CoreDataProperties.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//
//

import Foundation
import CoreData

// MARK: - CLASS DEFINITION
public class LogEntry: NSManagedObject { }

// MARK: - PROPERTIES
extension LogEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogEntry> {
        
        return NSFetchRequest<LogEntry>(entityName: "LogEntries")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
}

// MARK: - DECLARE CLASS IDENTIFIABLE
extension LogEntry : Identifiable { }
