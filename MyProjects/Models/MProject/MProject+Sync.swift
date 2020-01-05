//
//  MProject+Edit.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MProject {
    func sync(to model: AddProjectViewModel) {
        name = model.name
        details = model.details
        
        if model.hasDeadline {
            deadline = model.deadline
        } else {
            deadline = nil
        }
    }
}
