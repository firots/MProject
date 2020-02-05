//
//  AddTaskView.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var model: AddTaskViewModel
    @ObservedObject private var keyboard: KeyboardResponder
    var moc: NSManagedObjectContext
    @Environment(\.editMode) var editMode
    
    init(task: MTask?, project: MProject?, context moc: NSManagedObjectContext, pCellViewModel: ProjectCellViewModel?) {
        model = AddTaskViewModel(task, project, pCellViewModel: pCellViewModel)
        keyboard = KeyboardResponder()
        self.moc = moc
    }

    var body: some View {
        VStack {
            titleBar()
            MObjectStatePicker(statusIndex: $model.statusIndex)
            
            ZStack {
                Form {
                    stepsSection()
                    AddMObjectView(model: model)
                }
                
                expiredText()
            }.padding(.bottom, keyboard.currentHeight)
            .background(Color(.systemGroupedBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $model.showModal) {
            if (self.model.modalType == .notes) {
                NotesView(notes: self.$model.details, title: "Details", keyboard: self.keyboard)
            } else if (self.model.modalType == .addStep) {
                AddStepView(model: self.model.stepsModel.stepViewModel, newStep: self.model.stepsModel.newStep, keyboard: self.keyboard) {
                    self.model.stepsModel.steps.append(self.model.stepsModel.stepViewModel)
                }
            } else if (self.model.modalType == .addNotification) {
                AddNotificationView(notification: self.model.notificationsModel.notificationToAdd, keyboard: self.keyboard, isNew: self.model.notificationsModel.isNew) {
                    self.model.notificationsModel.notifications.append(self.model.notificationsModel.notificationToAdd)
                }
            } else {
                SelectTaskRepeatModeView(taskModel: self.model, keyboard: self.keyboard)
            }
        }
    }
    
    
    func expiredText() -> some View {
        TopWarningView(text: "This task will fail, please change or disable the deadline.", show: model.showExpiredWarning)
            .animation(.easeInOut)
    }
    
    func stepsSection() -> some View {
        StepsView(model: model.stepsModel) {
            self.model.modalType = .addStep
            self.model.showModal = true
        }
        .onLongPressGesture {
            if !self.model.stepsModel.steps.isEmpty {
                withAnimation {
                    if self.editMode?.wrappedValue != .active {
                        self.editMode?.wrappedValue = .active
                    }
                    self.model.editVisible = true
                }
            }
        }
    }
    
    func save() {
        let _ = MTask.createOrSync(from: self.model, context: self.moc, task: self.model.task, project: self.model.project, originalID: nil, repeatCount: 0)
        
        model.pCellViewModel?.refreshProgress()

        if self.moc.hasChanges {
            do {
                try self.moc.mSave()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    func titleBar() -> some View {
        ModalTitle(title: model.task == nil ? "Add New Task": "Edit Task", edit: model.editVisible) {
            self.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddTaskView(task: nil, project: nil, context: moc, pCellViewModel: nil)
    }
}
