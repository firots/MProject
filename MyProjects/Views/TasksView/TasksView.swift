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
    @Environment(\.managedObjectContext) private var moc
    
    init(project: MProject?) {
        model = TasksViewModel(project: project)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(Date().toClassic()).padding(.leading, 20)
                    Spacer()
                }
                listTasks()
            }
            AddButton() {
                self.model.taskToEdit = nil
                self.model.showAddTask = true
            }
        }
        .navigationBarTitle(model.project?.wrappedName ?? "My Tasks")
        .sheet(isPresented: $model.showAddTask)  {
            AddTaskView(task: self.model.taskToEdit, project: self.model.project, context: self.moc)
        }
    }
    
    private func listTasks() -> some View {
        FilteredList(predicate: model.predicate) { (task: MTask) in
            self.taskCell(task)
        }
    }
    
    private func taskCell(_ task: MTask) -> some View {
        Button(action: {
            self.model.taskToEdit = task
            self.model.showAddTask = true
        }) {
            VStack(alignment: .leading) {
                Text(task.wrappedName)
                Text(task.wrappedDetails).font(.footnote)
                Text("Due: \(task.deadline?.toRelative() ?? "No Deadline")").font(.footnote)
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(project: nil)
    }
}
