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
        t.setMutualFields(from: model)
        t.project = project
        t.syncSteps(with: model.stepsModel.steps, context: moc)
        return t
    }
    
    func clearSteps(context moc: NSManagedObjectContext) {
        for step in steps {
            moc.delete(step)
        }
    }
    
    func syncSteps(with stepModels: [StepCellViewModel], context moc: NSManagedObjectContext) {
        clearSteps(context: moc)
        var steps = [MStep]()

        for (i, stepModel) in stepModels.enumerated() {
            let step = MStep.create(from: stepModel, context: moc, rank: i)
            step.task = self
            steps.append(step)
        }

        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MTask {
        let task = MTask(context: moc)
        task.id = UUID()
        task.created = Date()
        task.details = ""
        
        return task
    }
}
