//
//  MProject+Create.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MProject {
    static func createOrSync(from model: AddProjectViewModel, context moc: NSManagedObjectContext, project: MProject?) -> MProject {
        let p = project ?? createBase(context: moc)
        p.setMutualFields(from: model, context: moc)
        p.syncNotifications(with: model.notificationsModel.notifications, context: moc)
        return p
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MProject {
        let project = MProject(context: moc)
        project.id = UUID()
        project.created = Date()
        project.details = ""

        return project
    }
    
    func clearTasks(context moc: NSManagedObjectContext) {
        for task in tasks {
            moc.deleteWithChilds(task)
        }
    }
}
