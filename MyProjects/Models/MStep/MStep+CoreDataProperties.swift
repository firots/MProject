//
//  MStep+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData


extension MStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MStep> {
        return NSFetchRequest<MStep>(entityName: "MStep")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var done: Bool
    @NSManaged public var created: Date?
    @NSManaged public var task: MTask?
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var wrappedID: UUID {
        return id ?? UUID()
    }
}
