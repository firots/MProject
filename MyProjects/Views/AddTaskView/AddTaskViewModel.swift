//
//  AddTaskViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    @Published var name = ""
    @Published var details = ""
    @Published var deadline = Date()
    @Published var hasDeadline = false
    @Published var statusIndex: Int
    
    let project: MProject?
    let task: MTask?
    
    init(_ task: MTask?, _ project: MProject?) {
        self.project = project
        self.task = task
        self.statusIndex = MTask.TaskStatus.all.firstIndex(of: MTask.TaskStatus(rawValue: task?.status ?? MTask.TaskStatus.active.rawValue) ?? MTask.TaskStatus.active) ?? 0
        
        if let t = task {
            name = t.name ?? ""
            details = t.details ?? ""
            if let deadline = t.deadline {
                hasDeadline = true
                self.deadline = deadline
            }
        }
    }
}
