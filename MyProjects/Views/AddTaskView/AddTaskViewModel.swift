//
//  AddTaskViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddTaskViewModel: AddMObjectViewModel {
    
    @Published var ended = Date()
    @Published var autoStart = Date()
    @Published var showAutoStart = false
    
    let project: MProject?
    let task: MTask?
    
    init(_ task: MTask?, _ project: MProject?) {
        self.project = project
        self.task = task
        super.init(mObject: task)
        
        if let t = task {
            if let started = t.started, started > Date() { autoStart = started }
            if let ended = t.ended { self.ended = ended }
        }
    }
}
