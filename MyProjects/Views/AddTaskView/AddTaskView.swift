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
    
    init(task: MTask?, project: MProject?, context moc: NSManagedObjectContext) {
        model = AddTaskViewModel(task, project)
        keyboard = KeyboardResponder()
        self.moc = moc
    }

    var body: some View {
        VStack {
            titleBar()
            MObjectStatePicker(statusIndex: $model.statusIndex)
            expiredText()
            
            Form {
                stepsSection()
                AddMObjectView(model: model)
            }.background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.bottom, self.model.showModal == false  ? keyboard.currentHeight : 0)
        .sheet(isPresented: $model.showModal) {
            if (self.model.modalType == .notes) {
                NotesView(notes: self.$model.details, keyboard: self.keyboard)
            } else if (self.model.modalType == .addStep) {
                AddStepView(model: self.model.stepsModel.stepViewModel, newStep: self.model.stepsModel.newStep, keyboard: self.keyboard) {
                    self.model.stepsModel.steps.append(self.model.stepsModel.stepViewModel)
                }
            } else {
                Text("Add Notification")
            }
        }
    }
    
    func expiredText() -> some View {
        Group {
            if model.showExpiredWarning {
                Text("This task will fail, please change or disable the deadline.")
                    .font(.footnote)
                    .foregroundColor(Color(.systemRed))
                    .padding(.horizontal, 20)
            }
        }
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
        let _ = MTask.createOrSync(from: self.model, context: self.moc, task: self.model.task, project: self.model.project)

        if self.moc.hasChanges {
            do {
                try self.moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    func titleBar() -> some View {
        ModalTitle(title: model.task == nil ? "Add Task": "Edit Task", edit: model.editVisible) {
            self.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddTaskView(task: nil, project: nil, context: moc)
    }
}
