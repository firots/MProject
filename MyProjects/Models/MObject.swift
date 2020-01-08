//
//  MObject.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

protocol MObject {
    var id: UUID? { get  set }
    var name: String? { get  set }
    var details: String? { get  set }
    var created: Date? { get  set }
    var started: Date?  { get  set }
    var deadline: Date? { get  set }
    var status: String? { get  set }
    var ended: Date? { get  set }
    var lastModified: Date? { get  set }
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
}

public enum MObjectStatus: String {
    case active
    case waiting
    case done
    case expired
    
    static let all = [active, waiting, done, expired]
    
    static let colors = [Color(UIColor.systemBackground), Color.yellow, Color.green, Color.red]
    
    static let emptyProjectTitles = ["No projects", "No active projects", "No waiting projects", "No projects completed", "No expired projects"]
    
    static let emptyProjectSubtitles = ["Lets add some?", "Fine...", "Good...", "Lets do some!", "Wow!" ]
    
    static let emptyTaskTitles = ["No tasks", "No active tasks", "No waiting tasks", "No tasks completed", "No expired tasks"]
    
    static let emptyTaskSubtitles = ["Lets add some?", "Fine...", "Good...", "Lets do some!", "Wow!" ]
    
}
