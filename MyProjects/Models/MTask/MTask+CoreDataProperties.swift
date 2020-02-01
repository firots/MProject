//
//  MTask+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData


extension MTask: HasRepeatMode {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MTask> {
        return NSFetchRequest<MTask>(entityName: "MTask")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var created: Date?
    @NSManaged public var started: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var status: Int
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var project: MProject?
    @NSManaged public var priority: Int
    @NSManaged public var step: NSSet?
    @NSManaged public var notification: NSSet?
    @NSManaged public var saved: Bool
    @NSManaged public var original: UUID?
    
    /* Repeat Section */
    @NSManaged public var nextFireDate: Date?
    @NSManaged public var repeatEndDate: Date?
    @NSManaged public var selectedDays: [Int]
    @NSManaged public var repeatMode: Int
    @NSManaged public var repeatStartDate: Date?
    @NSManaged public var repeatPeriod: Int
    @NSManaged public var repeatTask: MTask?
    @NSManaged public var repeatedFrom: MTask?
    @NSManaged public var repeatedID: UUID?
    
    public var steps: [MStep] {
        let set = step as? Set<MStep> ?? []
        return set.sorted {
            $0.rank < $1.rank
        }
    }
    
    public var completedSteps: [MStep] {
        steps.filter({ $0.status == MStepStatus.done.rawValue })
    }
}


// MARK: Generated accessors for notification
extension MTask {

    @objc(addNotificationObject:)
    @NSManaged public func addToNotification(_ value: MNotification)

    @objc(removeNotificationObject:)
    @NSManaged public func removeFromNotification(_ value: MNotification)

    @objc(addNotification:)
    @NSManaged public func addToNotification(_ values: NSSet)

    @objc(removeNotification:)
    @NSManaged public func removeFromNotification(_ values: NSSet)

}

// MARK: Generated accessors for step
extension MTask {

    @objc(addStepObject:)
    @NSManaged public func addToStep(_ value: MStep)

    @objc(removeStepObject:)
    @NSManaged public func removeFromStep(_ value: MStep)

    @objc(addStep:)
    @NSManaged public func addToStep(_ values: NSSet)

    @objc(removeStep:)
    @NSManaged public func removeFromStep(_ values: NSSet)

}
