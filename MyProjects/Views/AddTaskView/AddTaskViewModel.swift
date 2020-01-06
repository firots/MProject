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
    
    let project: MProject?
    let task: MTask?
    
    init(_ task: MTask?, _ project: MProject?) {
        self.project = project
        self.task = task
    }
}
