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
    @NSManaged public var deadline: Date?
    @NSManaged public var status: String?
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var project: MProject?
    @NSManaged public var precondition: NSSet?
    @NSManaged public var involved: NSSet?
    
    public var wrappedCreated: Date {
        return created ?? Date()
    }
    
    public var preconditions: [MTask] {
        let set = precondition as? Set<MTask> ?? []
        
        return set.sorted {
            $0.wrappedCreated > $1.wrappedCreated
        }
    }
    
    public var involvedTasks: [MTask] {
        let set = involved as? Set<MTask> ?? []
        
        return set.sorted {
            $0.wrappedCreated > $1.wrappedCreated
        }
    }

}

// MARK: Generated accessors for precondition
extension MTask {

    @objc(addPreconditionObject:)
    @NSManaged public func addToPrecondition(_ value: MTask)

    @objc(removePreconditionObject:)
    @NSManaged public func removeFromPrecondition(_ value: MTask)

    @objc(addPrecondition:)
    @NSManaged public func addToPrecondition(_ values: NSSet)

    @objc(removePrecondition:)
    @NSManaged public func removeFromPrecondition(_ values: NSSet)

}

// MARK: Generated accessors for involved
extension MTask {

    @objc(addInvolvedObject:)
    @NSManaged public func addToInvolved(_ value: MTask)

    @objc(removeInvolvedObject:)
    @NSManaged public func removeFromInvolved(_ value: MTask)

    @objc(addInvolved:)
    @NSManaged public func addToInvolved(_ values: NSSet)

    @objc(removeInvolved:)
    @NSManaged public func removeFromInvolved(_ values: NSSet)

}
