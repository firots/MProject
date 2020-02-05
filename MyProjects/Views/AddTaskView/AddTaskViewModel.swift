//
//  AddTaskViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddTaskViewModel: AddMObjectViewModel {
    @Published var editVisible = false
    @Published var repeatModeConfiguration: ConfigureRepeatModeViewModel<MTask>
    let project: MProject?
    let task: MTask?
    weak var pCellViewModel: ProjectCellViewModel?
    
    var stepsModel: StepsViewModel
    
    init(_ task: MTask?, _ project: MProject?, pCellViewModel: ProjectCellViewModel?) {
        self.project = project
        self.task = task
        self.repeatModeConfiguration = ConfigureRepeatModeViewModel(from: task, type: .task)
        self.pCellViewModel = pCellViewModel
        
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


