//
//  StepCellViewModel.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class StepCellViewModel: ObservableObject, Identifiable {
    var id: UUID
    @Published var name: String
    @Published var editing: Bool
    var done: Bool
    var created: Date
    var task: MTask?
    
    init(name: String?, done: Bool, created: Date, task: MTask?) {
        self.id = UUID()
        self.name = name ?? ""
        self.done = done
        self.created = created
        self.task = task
        self.editing = true
    }
    
    init(step: MStep) {
        self.id = step.wrappedID
        self.name = step.name ?? ""
        self.done = step.done
        self.created = step.wrappedCreated
        self.task = step.task
        self.editing = false
    }
}
