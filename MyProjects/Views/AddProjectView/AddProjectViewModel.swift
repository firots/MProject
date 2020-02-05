//
//  AddProjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class AddProjectViewModel: AddMObjectViewModel {
    let project: MProject?
    
    init(project: MProject?) {
        self.project = project
        
        super.init(mObject: project)
        
        self.created = project?.created
    }
}
