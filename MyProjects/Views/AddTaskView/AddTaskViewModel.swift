//
//  AddTaskViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    let project: MProject?
    
    init(_ project: MProject?) {
        self.project = project
    }
}
