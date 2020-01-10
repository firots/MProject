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
                taskFilter()
                listTasks()
            }
            hoveringButtons()
        }
        .navigationBarTitle(model.project?.wrappedName ?? "My Tasks")
        .sheet(isPresented: $model.showAdd)  {
            if self.model.modalType == .addTask {
                AddTaskView(task: self.model.taskToEdit, project: self.model.project, context: self.moc)
            } else {
                AddProjectView(context: self.moc, project: self.model.project)
            }
        }
    }
    
    private func hoveringButtons() -> some View {
        VStack {
            Spacer()
            if model.project != nil {
                HoveringButton(color: Color(.systemPurple), image: Image(systemName: "pencil")) {
                    self.model.modalType = .addProject
                    self.model.taskToEdit = nil
                    self.model.showAdd = true
                }
            }
            HoveringButton(color: Color(.systemPurple), image: Image(systemName: "plus")) {
                self.model.modalType = .addTask
                self.model.taskToEdit = nil
                self.model.showAdd = true
            }
        }
    }
    
    private func listTasks() -> some View {
        FilteredList(predicate: model.predicate, placeholder: PlaceholderViewModel(title: MObjectStatus.emptyTaskTitles[model.taskFilter], subtitle: MObjectStatus.emptyTaskSubtitles[model.taskFilter], image: UIImage(named: "pencil"))) { (task: MTask) in
            self.taskCell(task)
        }
    }
    
    private func taskFilter() -> some View {
        Picker(selection: $model.taskFilter, label: Text("Show")) {
            ForEach(0..<MObjectStatus.all.count + 1) { index in
                Text(self.model.taskFilterTypeNames[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    private func taskCell(_ task: MTask) -> some View {
        Button(action: {
            self.model.taskToEdit = task
            self.model.modalType = .addTask
            self.model.showAdd = true
        }) {
            HStack {
                checkmarkButton(task)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(task.wrappedName)
                        .lineLimit(1)
                Spacer()
                    
                Text(task.wrappedDetails)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                    
                Text(task.deadline != nil ? task.deadline!.toRelative() : "No deadline")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(Color(.placeholderText))
                    
                }.foregroundColor(Color(.label))
            }
        }
    }
    
    func saveChanges() {
        if self.moc.hasChanges {
            do {
                try self.moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkmarkButton(_ task: MTask) -> some View {
        CheckmarkButton(status: task.wrappedStatus) {
            if task.wrappedStatus == .active {
                task.complete()
                self.saveChanges()
            } else if task.wrappedStatus == .done {
                task.uncomplete()
                self.saveChanges()
            } else {
                self.model.taskToEdit = task
                self.model.modalType = .addTask
                self.model.showAdd = true
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(project: nil)
    }
}
