//
//  MProject+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension MProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MProject> {
        return NSFetchRequest<MProject>(entityName: "MProject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var status: Int
    @NSManaged public var details: String?
    @NSManaged public var started: Date?
    @NSManaged public var created: Date?
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var task: NSSet?
    @NSManaged public var notification: NSSet?
    @NSManaged public var priotory: Int
    @NSManaged public var saved: Bool
    @NSManaged public var progress: Float
    
    public var tasks: [MTask] {
        let set = task as? Set<MTask> ?? []
        
        return set.sorted {
            $0.wrappedCreated > $1.wrappedCreated
        }
    }
    
    public func setProgress() {
        if tasks.isEmpty {
            progress = Float.zero
        } else {
            let completed = tasks.filter( { $0.wrappedStatus == .done} ).count
            progress = Float(completed) / Float(tasks.count)
        }
    }
    
    public var wrappedProgress: CGFloat {
        return CGFloat(progress)
    }
    
    public var progressPercentage: Int {
        Int(100 * wrappedProgress)
    }
}

// MARK: Generated accessors for notification
extension MProject {

    @objc(addNotificationObject:)
    @NSManaged public func addToNotification(_ value: MNotification)

    @objc(removeNotificationObject:)
    @NSManaged public func removeFromNotification(_ value: MNotification)

    @objc(addNotification:)
    @NSManaged public func addToNotification(_ values: NSSet)

    @objc(removeNotification:)
    @NSManaged public func removeFromNotification(_ values: NSSet)

}

// MARK: Generated accessors for task
extension MProject {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: MTask)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: MTask)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}
