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
    @NSManaged public var notes: String?
    @NSManaged public var created: Date?
    @NSManaged public var lastModified: Date?
    
    public var wrappedID: UUID {
        return id ?? UUID()
    }
    
    public var wrappedName: String {
        return name ?? "Unnamed Project"
    }
    
    public var wrappedStatus: MProject.ProjectStatus {
        return ProjectStatus(rawValue: status ?? ProjectStatus.active.rawValue) ?? .active
    }
    
    public var wrappedNotes: String {
        return notes ?? ""
    }
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var wrappedLastModified: Date {
        return lastModified ?? wrappedCreated
    }
}
