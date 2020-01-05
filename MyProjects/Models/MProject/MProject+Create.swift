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
    static func create(from model: AddProjectViewModel) -> MProject {
        let project = createBase()
        
        return project
    }
    
    static func createBase() -> MProject {
        let project = MProject()
        project.id = UUID()
        project.created = Date()
        
        return project
    }
}
