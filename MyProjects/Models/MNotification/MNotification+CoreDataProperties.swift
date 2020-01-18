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

    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var repeatHour: Int
    @NSManaged public var repeatInterval: Int
    @NSManaged public var repeatMinute: Int
    @NSManaged public var repeatMode: Int
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var repeatPeriod: Int
    @NSManaged public var project: MProject?
    @NSManaged public var task: MTask?
    
    public var wrappedID: UUID {
        return id ?? UUID()
    }
}
