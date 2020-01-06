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


extension MProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MProject> {
        return NSFetchRequest<MProject>(entityName: "MProject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var details: String?
    @NSManaged public var created: Date?
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var task: NSSet?
    
    public var wrappedID: UUID {
        return id ?? UUID()
    }
    
    public var wrappedName: String {
        return name ?? "Unnamed Project"
    }
    
    public var wrappedStatus: MProject.ProjectStatus {
        return ProjectStatus(rawValue: status ?? ProjectStatus.active.rawValue) ?? .active
    }
    
    public var wrappedDetails: String {
        return details ?? "No Details"
    }
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var wrappedLastModified: Date {
        return lastModified ?? wrappedCreated
    }
    
    public var tasks: [MTask] {
        let set = task as? Set<MTask> ?? []
        
        return set.sorted {
            $0.wrappedCreated > $1.wrappedCreated
        }
    }
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
