//
//  TasksViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class TasksViewModel: ObservableObject {
    @Published var showAddTask = false
    @Published var taskFilter = 1
    @Published var predicate: NSPredicate?

    var taskFilterTypeNames: [String] = MTask.TaskStatus.all.map( {$0.rawValue.capitalizingFirstLetter()} )
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    let project: MProject?
    
    init(project: MProject?) {
        taskFilterTypeNames.insert("All", at: 0)
        
        self.project = project
        if let project = project {
             predicate = NSPredicate(format: "project == %@", project)
        }
    }

}
