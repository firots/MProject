//
//  MNotification+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 16.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData


extension MNotification: HasRepeatMode {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MNotification> {
        return NSFetchRequest<MNotification>(entityName: "MNotification")
    }

    /* Main */
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var message: String?
    @NSManaged public var date: Date?
    @NSManaged public var created: Date?
    @NSManaged public var nextFireDate: Date?
    
    /* Belongs to */
    @NSManaged public var project: MProject?
    @NSManaged public var task: MTask?
    
    /* Repeat Section */
    @NSManaged public var repeatEndDate: Date?
    @NSManaged public var selectedDays: [Int]
    @NSManaged public var repeatMode: Int
    @NSManaged public var repeatStartDate: Date?
    @NSManaged public var repeatPeriod: Int
    @NSManaged public var subID: [UUID]

    /* Optional Handling */
    public var wrappedID: UUID {
        return id ?? UUID()
    }
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var wrappedTitle: String {
        title?.emptyHolder(mObject?.wrappedName ?? "Undefined Notification") ?? "Undefined Notification"
    }
    
    public var wrappedMessage: String {
        message ?? ""
    }
}
