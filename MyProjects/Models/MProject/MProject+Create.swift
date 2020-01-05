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
    static func create(from model: AddProjectViewModel, context moc: NSManagedObjectContext) -> MProject {
        let project = createBase(context: moc)
        
        project.name = model.name
        project.details = model.details
        
        return project
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MProject {
        let project = MProject(context: moc)
        project.id = UUID()
        project.created = Date()
        project.status = ProjectStatus.active.rawValue
        
        return project
    }
}
