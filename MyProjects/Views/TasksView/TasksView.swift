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
    @State private var sheetOn = false
    
    init(project: MProject?) {
        model = TasksViewModel(project: project)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(Date().toClassic()).padding(.leading, 20)
                    MObjectNavigationButtons()
                    Spacer()
                }
                ZStack {
                    listTasks()
                    taskFilter()
                }
            }
            hoveringButtons()
        }
        .navigationBarTitle(model.project?.wrappedName ?? "My Tasks")
        .sheet(isPresented: self.$model.showAdd)  {
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
        VStack {
            Picker(selection: $model.taskFilter, label: Text("Show")) {
                ForEach(0..<MObjectStatus.all.count + 1) { index in
                    Text(self.model.taskFilterTypeNames[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemBackground))
            Spacer()
        }
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
                    taskCellNameAndSteps(task)
                        .padding(.bottom, 5)
                    
                    taskCellStartDates(task)
                        .padding(.bottom, 5)
                    
                    taskCellStartDates(task)
                        .padding(.bottom, 5)
                    
                }.foregroundColor(Color(.label))
            }
            .padding(.bottom, 5)
        }.listRowBackground(cellBackgroundColor)
    }
    
    private func taskCellNameAndSteps(_ task: MTask) -> some View {
        HStack {
            Text(task.wrappedName)
                 .strikethrough(task.wrappedStatus == .done, color: nil)
                 .lineLimit(1)
             
             Spacer()
             
             if !task.steps.isEmpty {
                 
                 Text("\(task.completedSteps.count)/\(task.steps.count)")
                    .strikethrough(task.steps.count == task.completedSteps.count, color: nil)
                    .font(.system(size: 20, design: .monospaced))
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(Color(.systemGray))
             }
        }
    }
    
    private func taskCellEndDates(_ task: MTask) -> some View {
        HStack {
            Text(task.secondDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if task.deadline != nil && (task.wrappedStatus == .active || task.wrappedStatus == .waiting )  {
                Text(task.deadline!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemRed))
            }
            
            
        }
    }
    
    private func taskCellStartDates(_ task: MTask) -> some View {
        HStack {
            Text(task.firstDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if task.started != nil && task.wrappedStatus == .waiting  {
                Text(task.started!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemOrange))
            }
        }
    }

    
    private var cellBackgroundColor: Color {
        Color(.systemBackground)
    }

    private var cellColor: Color {
        Color(.systemBackground)
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
                task.wrappedStatus = .done
                Haptic.feedback(.medium)
                self.saveChanges()
            } else if task.wrappedStatus == .done {
                task.wrappedStatus = .active
                if task.wrappedStatus == .active {
                    Haptic.feedback(.light)
                } else {
                    Haptic.notify(.error)
                }
                self.saveChanges()
            } else {
                Haptic.notify(.warning)
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
