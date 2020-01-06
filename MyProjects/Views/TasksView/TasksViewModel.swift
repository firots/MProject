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
    
    var taskToEdit: MTask?

    var taskFilterTypeNames: [String] = MTask.TaskStatus.all.map( {$0.rawValue.capitalizingFirstLetter()} )
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    let project: MProject?
    
    private var filterTasksPublisher: AnyPublisher<NSPredicate?, Never> {
        $taskFilter
            .map { taskFilter in
                if taskFilter == 0 {
                    if self.project == nil {
                        return nil
                    } else {
                        return NSPredicate(format: "project == %@", self.project!)
                    }
                } else {
                    if self.project == nil {
                        return NSPredicate(format: "status == %@", MTask.TaskStatus.all[taskFilter - 1].rawValue)
                    } else {
                        return NSPredicate(format: "status == %@ AND project == %@", MTask.TaskStatus.all[taskFilter - 1].rawValue, self.project!)
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    init(project: MProject?) {
        taskFilterTypeNames.insert("All", at: 0)
        self.project = project

        filterTasksPublisher
            .receive(on: RunLoop.main)
            .map {predicate in
                predicate
        }
        .assign(to: \.predicate, on: self)
        .store(in: &cancellableSet)
    }

}
