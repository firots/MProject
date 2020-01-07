//
//  AddMObjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class AddMObjectViewModel: ObservableObject {
    @Published var name = ""
    @Published var details = ""
    @Published var deadline = Date()
    @Published var hasDeadline = false
    
    var project: MProject?
    
    init(project: MProject?) {
        self.project = project
        if let p = project {
            name = p.name ?? ""
            details = p.details ?? ""
            if let deadline = p.deadline {
                hasDeadline = true
                self.deadline = deadline
            }
        }
    }
}
