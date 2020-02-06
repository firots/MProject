//
//  MAttachment+CoreDataProperties.swift
//  MyProjects
//
//  Created by Firot on 6.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
//

import Foundation
import CoreData


extension MAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MAttachment> {
        return NSFetchRequest<MAttachment>(entityName: "MAttachment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var created: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var task: MTask?
    @NSManaged public var project: MProject?
    @NSManaged public var url: URL?
    @NSManaged public var storedName: String?

}
