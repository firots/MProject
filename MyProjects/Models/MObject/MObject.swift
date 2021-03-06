//
//  MObject.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

protocol MObject: NSManagedObject, HasDateStamp {
    var id: UUID? { get  set }
    var name: String? { get  set }
    var details: String? { get  set }
    var created: Date? { get  set }
    var started: Date?  { get  set }
    var deadline: Date? { get  set }
    var status: Int { get  set }
    var ended: Date? { get  set }
    var lastModified: Date? { get  set }
    var priority: Int { get set }
    var notification: NSSet? { get  set }
    var saved: Bool { get set }
}

extension MObject {
    public var wrappedID: UUID {
        return id ?? UUID()
    }
    
    public var color: UIColor {
        .systemPurple
    }
    
    public var wrappedName: String {
        return name ?? "Unnamed \(self is MProject ? "Project" : "Task")"
    }
    
    public var notifications: [MNotification] {
        let set = notification as? Set<MNotification> ?? []
        return set.sorted {
            $0.wrappedCreated < $1.wrappedCreated
        }
    }
    
    public var isExpired: Bool {
        if deadline == nil {
            return false
        } else if let deadline = deadline, deadline > Date() {
            return false
        }
        return true
    }
    
    public func setStatus(to newStatus: MObjectStatus, context: NSManagedObjectContext, noResyncNotifications: Bool) {
        if (newStatus == .failed && self.wrappedStatus != MObjectStatus.failed) || (newStatus == .done && self.wrappedStatus != MObjectStatus.done) {
            self.ended = Date()
        } else {
            self.ended = nil
        }
        
        if newStatus == .active && isExpired {
            self.status = MObjectStatus.failed.rawValue
        } else {
            self.status = newStatus.rawValue
        }
        
        if self.status == MObjectStatus.failed.rawValue || self.status == MObjectStatus.done.rawValue {
            if let task = self as? MTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let context = self.managedObjectContext {
                        task.repeatIfNeeded(force: true, context: context, count: 1 )
                    }
                }
            }
            deleteNotificationsFromIOS(clearFireDate: true)
        } else {
            if noResyncNotifications == false {
                resyncNotifications()
            }
        }
    }
    
    public var wrappedStatus: MObjectStatus {
        get {
            return MObjectStatus(rawValue: status) ?? .active
        }
    }
    
    public var wrappedDetails: String {
        return details ?? "No Details"
    }
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var wrappedStarted: Date {
        return started ?? wrappedCreated
    }
    
    public var wrappedLastModified: Date {
        return lastModified ?? wrappedCreated
    }
    
    
    
    func setMutualFields(from model: AddMObjectViewModel, context: NSManagedObjectContext) {
        self.name = model.name.emptyIsNil()
        self.details = model.details.emptyIsNil()
        self.priority = model.priority
        if model.hasAutoStart == true && model.status == .waiting {
            self.started = model.autoStart
        } else if model.hasAutoStart == false && model.status == .waiting {
            self.started = nil
        } else {
            self.started = model.started
        }
        
        /* set deadline if user set one */
        if model.hasDeadline {
            self.deadline = model.deadline
        } else {
            self.deadline = nil
        }
        self.saved = true
    }
    
    public var secondDate: String {
        ended?.toRelative() ?? deadline?.toRelative() ?? "No Deadline"
    }
    
    public var firstDate: String {
        started?.toRelative() ?? "No Start Date"
    }
}

public enum MObjectPriority: Int {
    case veryLow
    case low
    case medium
    case high
    case veryHigh
    
    static let names = ["Very Low", "Low", "Medium", "High", "Very High"]
    static let all = [veryLow, low, medium, high, veryHigh]
    static let colors = [Color(.systemGray), Color(.systemGreen), Color(.systemBlue), Color(.systemOrange), Color(.systemRed) ]
    
}

public enum MObjectStatus: Int {
    case active
    case waiting
    case done
    case failed
    
    static let names = ["active", "waiting", "done", "failed"]
    
    static let all = [active, waiting, done, failed]
    
    static let colors = [Color(UIColor.systemBackground), Color(.systemOrange), Color(.systemGreen), Color(.systemRed)]
    
    static let barColors = [UIColor.systemPurple, UIColor.systemOrange, UIColor.systemGreen, UIColor.systemRed]
    
    static let emptyProjectTitles = ["No projects", "No active projects", "No waiting projects", "No projects completed", "No failed projects"]
    
    static let emptyProjectSubtitles = ["Let's add some?", "Fine...", "Good...", "Let's do some!", "Wow!" ]
    
    static let emptyTaskTitles = ["No tasks", "No active tasks", "No waiting tasks", "No tasks completed", "No failed tasks"]
    
    static let emptyTaskSubtitles = ["Let's add some?", "Fine...", "Good...", "Let's do some!", "Wow!" ]
    
}

public enum MObjectType {
    case project
    case task
}
