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
                listTasks()
                AddButton() {
                    self.model.showAddTask = true
                }
            }
            .navigationBarTitle("My Tasks")
        }
        .sheet(isPresented: $model.showAddTask)  {
            AddTaskView(project: self.model.project)
        }
    }
    
    private func listTasks() -> some View {
        FilteredList(predicate: model.predicate) { (task: MTask) in
            self.taskCell(task)
        }
    }
    
    private func taskCell(_ task: MTask) -> some View {
        VStack(alignment: .leading) {
            Text(task.wrappedName)
            Text(task.wrappedDetails).font(.footnote)
            Text("Due: \(task.deadline?.toString() ?? "No Deadline")").font(.footnote)
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(project: nil)
    }
}
