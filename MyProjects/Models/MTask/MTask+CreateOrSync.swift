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
    static func createOrSync(from model: AddTaskViewModel, context moc: NSManagedObjectContext, task: MTask?, project: MProject?, originalID: UUID?, repeatCount: Int) -> MTask {
        let t = task ?? createBase(context: moc)
        t.setMutualFields(from: model, context: moc)
        if project != nil { t.project = project }
        t.syncSteps(with: model.stepsModel.steps, context: moc)
        t.syncNotifications(with: model.notificationsModel.notifications, context: moc)
        t.setStatus(to: MObjectStatus.all[model.statusIndex], context: moc)
        t.repeatMode = model.repeatModeConfiguration.repeatMode
        if model.repeatModeConfiguration.wrappedRepeatMode != .none {
            model.repeatModeConfiguration.bind(to: t)
        }
        if repeatCount > 0 {
            t.repeatCount = repeatCount
        }
        if let originalID = originalID {
            t.originalID = originalID
        }
        
        t.nextFireDate = nil
        t.setNextFireDate(skipNow: model.cloning)
        return t
    }
    
    func clearSteps(context moc: NSManagedObjectContext) {
        for step in steps {
            moc.delete(step)
        }
    }
    
    func syncSteps(with stepModels: [StepCellViewModel], context moc: NSManagedObjectContext) {
        var newOrModifiedSteps = [MStep]()
        var stepsToDelete = steps

        for (i, stepModel) in stepModels.enumerated() {
            let step = MStep.createOrSync(from: stepModel, context: moc, rank: i)
            step.task = self
            newOrModifiedSteps.append(step)
            stepsToDelete.removeAll( where : { $0.wrappedID == stepModel.id })
        }
        
        for deletedStep in stepsToDelete {
            moc.delete(deletedStep)
        }

        /*if moc.hasChanges {
            try? moc.mSave()
        }*/
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MTask {
        let task = MTask(context: moc)
        task.id = UUID()
        task.details = ""

        return task
    }
}
