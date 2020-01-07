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


extension MTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MTask> {
        return NSFetchRequest<MTask>(entityName: "MTask")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var created: Date?
    @NSManaged public var started: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var status: String?
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var project: MProject?

}
