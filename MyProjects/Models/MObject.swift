//
//  MObject.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

protocol MObject: class {
    var id: UUID? { get  set }
    var name: String? { get  set }
    var details: String? { get  set }
    var created: Date? { get  set }
    var started: Date?  { get  set }
    var deadline: Date? { get  set }
    var status: String? { get  set }
    var ended: Date? { get  set }
    var lastModified: Date? { get  set }
    var priotory: Int { get set }
}

extension MObject {
    public var wrappedID: UUID {
        return id ?? UUID()
    }
    
    public var wrappedName: String {
        return name ?? "Unnamed \(self is MProject ? "Project" : "Task")"
    }
    
    public var wrappedStatus: MObjectStatus {
        return MObjectStatus(rawValue: status ?? MObjectStatus.active.rawValue) ?? .active
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
    
    func setMutualFields(from model: AddMObjectViewModel) {
        self.name = model.name.emptyIsNil()
        self.details = model.details.emptyIsNil()
        
        if self.status == nil && model.status == .active  {
            self.started = Date()
        }
        else if model.showAutoStart == true && model.status == .waiting {
            self.started = model.autoStart
        } else if self.wrappedStatus != .active && model.status == .active {
            self.started = Date()
        } else if model.showAutoStart == false && model.status == .waiting {
            self.started = nil
        }
        
        /* set deadline if user set one */
        if model.hasDeadline {
            self.deadline = model.deadline
        } else {
            self.deadline = nil
        }
        
        /* set end date if object state changed to failed or done */
        if (model.status == .failed && self.status != MObjectStatus.failed.rawValue) || (model.status == .done && self.status != MObjectStatus.done.rawValue) {
            self.ended = Date()
        } else {
            self.ended = nil
        }
        
        self.status = MObjectStatus.all[model.statusIndex].rawValue
    }
    
    public var secondDate: String {
        ended?.toRelative() ?? deadline?.toRelative() ?? "No Deadline"
    }
    
    public var firstDate: String {
        started?.toRelative() ?? "No Start Date"
    }
}

public enum MObjectStatus: String {
    case active
    case waiting
    case done
    case failed
    
    static let all = [active, waiting, done, failed]
    
    static let colors = [Color(UIColor.systemBackground), Color(.systemOrange), Color(.systemGreen), Color(.systemRed)]
    
    static let emptyProjectTitles = ["No projects", "No active projects", "No waiting projects", "No projects completed", "No failed projects"]
    
    static let emptyProjectSubtitles = ["Let's add some?", "Fine...", "Good...", "Let's do some!", "Wow!" ]
    
    static let emptyTaskTitles = ["No tasks", "No active tasks", "No waiting tasks", "No tasks completed", "No failed tasks"]
    
    static let emptyTaskSubtitles = ["Let's add some?", "Fine...", "Good...", "Let's do some!", "Wow!" ]
    
}

public enum MObjectType {
    case project
    case task
}
