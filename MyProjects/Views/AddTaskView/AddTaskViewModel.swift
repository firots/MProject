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
    
    var stepsModel: StepsViewModel
    
    init(_ task: MTask?, _ project: MProject?) {
        self.project = project
        self.task = task
        
        var steps = [StepCellViewModel]()
        
        if let task = task {
            for step in task.steps {
                let stepModel = StepCellViewModel(step: step)
                steps.append(stepModel)
            }
        }
        
        stepsModel = StepsViewModel(steps: steps)
        super.init(mObject: task)
        

    }
}


