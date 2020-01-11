//
//  MTask+CreateOrSync.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MTask {
    static func createOrSync(from model: AddTaskViewModel, context moc: NSManagedObjectContext, task: MTask?, project: MProject?) -> MTask {
        let t = task ?? createBase(context: moc)
        
        t.name = model.name.emptyIsNil()
        t.details = model.details.emptyIsNil()
        t.project = project
        t.status = MObjectStatus.all[model.statusIndex].rawValue
        
        if model.hasDeadline {
            t.deadline = model.deadline
        } else {
            t.deadline = nil
        }
        
        t.syncSteps(with: model.steps, context: moc)
        
        return t
    }
    
    func syncSteps(with stepModels: [StepCellViewModel], context moc: NSManagedObjectContext) {
        var steps = [MStep]()
        for stepModel in stepModels {
            let step = MStep.create(from: stepModel, context: moc)
            steps.append(step)
        }
        if moc.hasChanges { try? moc.save() }
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MTask {
        let task = MTask(context: moc)
        task.id = UUID()
        task.created = Date()
        task.status = MObjectStatus.active.rawValue
        task.details = ""
        
        return task
    }
}
