//
//  Project+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String?
    @NSManaged public var dcription: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var completed: Bool
    
    public var wrappedName: String {
        return name ?? "Unnamed Project"
    }
    
    public var wrappedDescription: String {
        return dcription ?? ""
    }
    
    public var wrappedStartDate: Date {
        return startDate ?? Date()
    }
}
