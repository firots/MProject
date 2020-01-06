//
//  TasksView.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject private var model: TasksViewModel
    
    init(project: MProject?) {
        model = TasksViewModel(project: project)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AddButton() {
                    self.model.showAddTask = true
                }
                Text("No tasks so far.")
            }
            .navigationBarTitle("My Tasks")
        }
        .sheet(isPresented: $model.showAddTask)  {
            AddTaskView()
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(project: nil)
    }
}
