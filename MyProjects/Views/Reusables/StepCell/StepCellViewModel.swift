//
//  StepCellViewModel.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class StepCellViewModel: ObservableObject {
    var id: UUID
    var name: String
    var done: Bool
    var created: Date
    var task: MTask?
    
    init(name: String?, done: Bool, created: Date, task: MTask?) {
        self.id = UUID()
        self.name = name ?? ""
        self.done = done
        self.created = created
    }
    
    init(step: MStep) {
        self.id = step.wrappedID
        self.name = step.name ?? ""
        self.done = step.done
        self.created = step.wrappedCreated
        self.task = step.task
    }
}
