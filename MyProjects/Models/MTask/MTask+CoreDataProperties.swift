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
    @NSManaged public var status: Int
    @NSManaged public var ended: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var project: MProject?
    @NSManaged public var repeatMode: Int
    @NSManaged public var priotory: Int
    @NSManaged public var step: NSSet?
    @NSManaged public var saved: Bool
    
    public var wrappedRepeatMode: RepeatMode {
        get {
            RepeatMode(rawValue: repeatMode) ?? RepeatMode.none
        } set {
            repeatMode = newValue.rawValue
        }
    }
    
    public var steps: [MStep] {
        let set = step as? Set<MStep> ?? []
        return set.sorted {
            $0.rank < $1.rank
        }
    }
    
    public var completedSteps: [MStep] {
        steps.filter({ $0.status == MStepStatus.done.rawValue })
    }

}

// MARK: Generated accessors for step
extension MTask {

    @objc(addStepObject:)
    @NSManaged public func addToStep(_ value: MStep)

    @objc(removeStepObject:)
    @NSManaged public func removeFromStep(_ value: MStep)

    @objc(addStep:)
    @NSManaged public func addToStep(_ values: NSSet)

    @objc(removeStep:)
    @NSManaged public func removeFromStep(_ values: NSSet)

}
