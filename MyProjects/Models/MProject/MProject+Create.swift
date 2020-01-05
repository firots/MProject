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
        
        p.name = model.name
        p.details = model.details
        
        if model.hasDeadline {
            p.deadline = model.deadline
        } else {
            p.deadline = nil
        }
        
        return p
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MProject {
        let project = MProject(context: moc)
        project.id = UUID()
        project.created = Date()
        project.status = ProjectStatus.active.rawValue
        
        return project
    }
}
