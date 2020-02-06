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
    
    init(project: MProject?, pCellViewModel: ProjectCellViewModel?) {
        model = TasksViewModel(project: project, pCellViewModel: pCellViewModel)
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
        .navigationBarItems(trailing: MObjectSortButtons(hasEdit: true, hasDetails: !isLargeList(), ascending: $model.filterContainer.ascending, editMode: $model.selectionEnabled, showDetails: $model.filterContainer.showDetails, sortAction: {
            self.sortButtonAction()
        }, filterAction: {
            self.filterButtonAction()
        })
            .popover(isPresented: $model.showSortPopUp) {
                self.sortPopOver()
            }
        )
        .navigationBarTitle(model.project?.wrappedName ?? MObjectDateFilterType.names[model.filterContainer.dateFilter])
        .sheet(isPresented: self.$model.showModal)  {
            if self.model.modalType == .addTask {
                if Settings.shared.pro == false && self.moc.hasTaskLimitReached() {
                    PurchaseView()
                } else {
                    AddTaskView(task: self.model.taskToEdit, project: self.model.project, context: self.moc, pCellViewModel: self.model.pCellViewModel)
                }
            } else {
                AddProjectView(context: self.moc, project: self.model.project)
            }
        }
        .alert(isPresented: $model.showMultiDeletionAlert) {
            multiDeletionAlert()
        }
        .actionSheet(isPresented: $model.showActionSheet) {
            actionSheet()
        }
    }
    
    func multiDeletionAlert() -> Alert {
        if model.selectedTasks.isEmpty {
            return Alert(title: Text("No Tasks Selected"), message: Text("Select the tasks you want to delete by tapping them"), dismissButton: .default(Text("Okay")))
            
            
        } else {
            return Alert(title: Text("Warning"), message: Text("Are you sure you want to delete \(model.selectedTasks.count) tasks?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteSelectedTasks()
                } , secondaryButton: .cancel())
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
    
    private func deleteSelectedTasks() {
        for task in self.model.selectedTasks {
            self.moc.deleteWithChilds(task)
        }
        self.model.selectedTasks.removeAll()
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    private func hoveringButtons() -> some View {
        VStack {
            Spacer()
            if model.selectionEnabled {
                HoveringButton(color: Color(.systemRed), image: Image(systemName: "trash.fill")) {
                    self.model.showMultiDeletionAlert = true
                }
            } else {
                if model.project != nil {
                    HoveringButton(color: Color(.systemPurple), image: Image(systemName: "pencil")) {
                        if self.model.project?.managedObjectContext != nil {
                            self.model.modalType = .addProject
                            self.model.taskToEdit = nil
                            self.model.showModal = true
                        }
                    }
                }
                HoveringButton(color: Color(.systemPurple), image: Image(systemName: "plus")) {
                    if let project = self.model.project, project.managedObjectContext == nil {
                        return
                    }
                    self.model.modalType = .addTask
                    self.model.taskToEdit = nil
                    self.model.showModal = true
                }
            }

        }
    }
    
    private func listTasks() -> some View {
        FilteredList(listID: model.filterContainer.listID,predicate: model.filterContainer.predicate, sorter: model.filterContainer.sortDescriptor, placeholder: PlaceholderViewModel(title: MObjectStatus.emptyTaskTitles[model.filterContainer.statusFilter], subtitle: MObjectStatus.emptyTaskSubtitles[model.filterContainer.statusFilter], image: UIImage(named: "pencil"))) { (task: MTask) in
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
    
    private func toggleSelection(of task: MTask) {
        if self.model.selectedTasks.contains(task) {
            self.model.selectedTasks.removeAll( where: { $0 == task })
        } else {
            self.model.selectedTasks.append(task)
        }

    }
    
    private func taskCell(_ task: MTask) -> some View {
        Button(action: {
            if self.model.selectionEnabled {
                self.toggleSelection(of: task)
            } else {
                self.model.taskToEdit = task
                self.model.modalType = .addTask
                self.model.showModal = true
            }
        }) {
            HStack {
                checkmarkButton(task)
                    .padding(.trailing)
                
                
                if isLargeList() {
                    HStack {
                        taskCellNameAndSteps(task)
                        
                        taskCellStartDates(task)
                            .transition(.slide)
                        
                        taskCellEndDates(task)
                            .transition(.slide)
                    
                        taskIcons(task).frame(minWidth: 60, alignment: .trailing)
                        
                    }.foregroundColor(Color(.label))
                } else {
                    VStack(alignment: .leading) {
                        taskCellNameAndSteps(task)
                        
                        if model.filterContainer.showDetails {
                            showSteps(task)
                                .padding(.bottom, 5)
                                .transition(.slide)
                            
                            taskCellStartDates(task)
                                .padding(.bottom, 5)
                                .transition(.slide)
                            
                            taskCellEndDates(task)
                                .padding(.bottom, 5)
                                .transition(.slide)
                        }

                        
                    }.foregroundColor(Color(.label))
                }
                

            }
            .padding(.bottom, 5)
        }.listRowBackground(self.model.selectedTasks.contains(task) ? Color(.systemGray4): cellBackgroundColor)
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
            Text(task.wrappedName)
                 .strikethrough(task.wrappedStatus == .done, color: nil)
                 .lineLimit(1)
            
            if isLargeList() {
                Spacer()
                
                
                showSteps(task)
                    .transition(.slide)
            }


            Spacer()
            

            if !isLargeList() {
                taskIcons(task)
            }
            
            
            
                
            
        }
    }
    
    private func showSteps(_ task: MTask) -> some View {
        Group {
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
    
    private func isLargeList() -> Bool {
        model.project == nil && UIDevice.current.userInterfaceIdiom != .phone
    }

    
    private func taskCellEndDates(_ task: MTask) -> some View {
        HStack {
            Text(task.secondDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            if !isLargeList() {
                Spacer()
            }
            
            
            if task.deadline != nil && (task.wrappedStatus == .active || task.wrappedStatus == .waiting )  {
                Text(task.deadline!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemRed))
            }
            
            if isLargeList() {
                Spacer()
            }
            
            
        }
    }
    
    private func taskCellStartDates(_ task: MTask) -> some View {
        HStack {
            Text(task.firstDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            if !isLargeList() {
                Spacer()
            }
            
            if task.started != nil && task.wrappedStatus == .waiting  {
                Text(task.started!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemOrange))
            }
            
            if isLargeList() {
                Spacer()
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
                try self.moc.mSave()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkmarkButton(_ task: MTask) -> some View {
        ZStack {
            CheckmarkButton(status: task.wrappedStatus) {
                if self.model.selectionEnabled { self.toggleSelection(of: task); return }
                if task.wrappedStatus == .active {
                    task.setStatus(to: .done, context: self.moc)
                    self.model.pCellViewModel?.refreshProgress()
                    Haptic.feedback(.medium)
                    task.deleteNotificationsFromIOS(clearFireDate: true)
                    self.saveChanges()
                } else if task.wrappedStatus == .done {
                    task.setStatus(to: .active, context: self.moc)
                    self.model.pCellViewModel?.refreshProgress()
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
                    self.model.showModal = true
                }
            }
            
            VStack {
                
                Spacer()
            }
        }

    }
}
