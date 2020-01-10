//
//  AddTaskViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddTaskViewModel: AddMObjectViewModel {
    let project: MProject?
    let task: MTask?
    
    @Published var steps = [StepCellViewModel]()
    
    init(_ task: MTask?, _ project: MProject?) {
        self.project = project
        self.task = task
        super.init(mObject: task)

    }
}


