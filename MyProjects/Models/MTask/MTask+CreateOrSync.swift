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
        t.status = TaskStatus.all[model.statusIndex].rawValue
        
        if model.hasDeadline {
            t.deadline = model.deadline
        } else {
            t.deadline = nil
        }
        
        return t
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MTask {
        let task = MTask(context: moc)
        task.id = UUID()
        task.created = Date()
        task.status = TaskStatus.active.rawValue
        task.details = ""
        
        return task
    }
}
