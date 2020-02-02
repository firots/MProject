//
//  TasksView.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct TasksView: View, MObjectLister {
    @ObservedObject var model: TasksViewModel
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var sheetOn = false
    
    init(project: MProject?) {
        model = TasksViewModel(project: project)
    }
    
    var isLargeTitle: Bool {
        (UIDevice.current.userInterfaceIdiom != .phone && model.project != nil)
    }
    
    var body: some View {
        ZStack {
            VStack {
                titleDate()
                ZStack {
                    listTasks()
                    taskFilter()
                }
            }
            hoveringButtons()
        }
        .navigationBarItems(trailing: MObjectSortButtons(ascending: $model.filterContainer.ascending, sortAction: {
            self.sortButtonAction()
        }, filterAction: {
            self.filterButtonAction()
        })
            .popover(isPresented: $model.showSortPopUp) {
                self.sortPopOver()
            }
        )
        .navigationBarTitle(model.project?.wrappedName ?? MObjectDateFilterType.names[model.filterContainer.dateFilter])
        .sheet(isPresented: self.$model.showAdd)  {
            if self.model.modalType == .addTask {
                AddTaskView(task: self.model.taskToEdit, project: self.model.project, context: self.moc)
            } else {
                AddProjectView(context: self.moc, project: self.model.project)
            }
        }
        .actionSheet(isPresented: $model.showActionSheet) {
            actionSheet()
        }.onDisappear() {
            self.model.filterContainer.savePreferences()
        }.onAppear() {
            MObjectFilterContainer.latestInstance = self.model.filterContainer
        }
    }
    
    func titleDate() -> some View {
        Group {
            if !isLargeTitle {
                HStack {
                    Text(Date().toClassic()).padding(.leading, isLargeTitle ? 0 : 22)
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
    }
    
    private func hoveringButtons() -> some View {
        VStack {
            Spacer()
            if model.project != nil {
                HoveringButton(color: Color(.systemPurple), image: Image(systemName: "pencil")) {
                    if self.model.project?.managedObjectContext != nil {
                        self.model.modalType = .addProject
                        self.model.taskToEdit = nil
                        self.model.showAdd = true
                    }
                }
            }
            HoveringButton(color: Color(.systemPurple), image: Image(systemName: "plus")) {
                if let project = self.model.project, project.managedObjectContext == nil {
                    self.presentationMode.wrappedValue.dismiss()
                    return
                }
                self.model.modalType = .addTask
                self.model.taskToEdit = nil
                self.model.showAdd = true
            }
        }
    }
    
    private func listTasks() -> some View {
        FilteredList(predicate: model.filterContainer.predicate, sorter: model.filterContainer.sortDescriptor, placeholder: PlaceholderViewModel(title: MObjectStatus.emptyTaskTitles[model.filterContainer.statusFilter], subtitle: MObjectStatus.emptyTaskSubtitles[model.filterContainer.statusFilter], image: UIImage(named: "pencil"))) { (task: MTask) in
            self.taskCell(task)
        }.padding(.top, topPadding)
    }
    

    private func taskFilter() -> some View {
        VStack {
            Picker(selection: $model.filterContainer.statusFilter, label: Text("Show")) {
                ForEach(0..<MObjectStatus.all.count + 1) { index in
                    Text(self.model.filterContainer.statusFilterTypeNames[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemBackground))
            
            if UIDevice.current.userInterfaceIdiom != .phone {
                dateFilter()
            }
            Spacer()
        }
    }
    
    private func dateFilter() -> some View {
        Picker(selection: $model.filterContainer.dateFilter, label: Text("Show")) {
            ForEach(0..<MObjectDateFilterType.all.count) { index in
                Text(MObjectDateFilterType.names[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
        .background(Color(.systemBackground))
        
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
                    
                    showSteps(task)
                        .padding(.bottom, 5)
                    
                    taskCellStartDates(task)
                        .padding(.bottom, 5)
                    
                    taskCellEndDates(task)
                        .padding(.bottom, 5)
                    
                }.foregroundColor(Color(.label))
            }
            .padding(.bottom, 5)
        }.listRowBackground(cellBackgroundColor)
    }
    
    private func taskIcons(_ task: MTask) -> some View {
        HStack {
            if !task.notifications.filter({ $0.nextFireDate != nil }).isEmpty {
                Image(systemName: "bell.circle.fill")
                    .foregroundColor(Color(.systemGray))
            }
            
            if task.wrappedRepeatMode != .none {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .foregroundColor(Color(task.repeated == false ? .systemGray: .systemRed))
            }
            
            Image(systemName: "flag.circle.fill")
                .foregroundColor(MObjectPriority.colors[task.priority])
        }
    }
    
    private func taskCellNameAndSteps(_ task: MTask) -> some View {
        HStack {
            Text("\(task.wrappedName) \(task.repeatCount)")
                 .strikethrough(task.wrappedStatus == .done, color: nil)
                 .lineLimit(1)

            Spacer()
            
            taskIcons(task)
                
            
        }
    }
    
    private func showSteps(_ task: MTask) -> some View {
        HStack {
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
        ZStack {
            CheckmarkButton(status: task.wrappedStatus) {
                if task.wrappedStatus == .active {
                    task.setStatus(to: .done, context: self.moc)
                    Haptic.feedback(.medium)
                    task.deleteNotificationsFromIOS(clearFireDate: true)
                    self.saveChanges()
                } else if task.wrappedStatus == .done {
                    task.setStatus(to: .active, context: self.moc)
                    if task.wrappedStatus == .active {
                        task.resyncNotifications()
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
            
            VStack {
                
                Spacer()
            }
        }

    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(project: nil)
    }
}
