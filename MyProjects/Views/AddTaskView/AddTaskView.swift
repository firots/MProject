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
    @State var editVisible = false
    @Environment(\.editMode) var editMode
    
    init(task: MTask?, project: MProject?, context moc: NSManagedObjectContext) {
        UITableView.appearance().backgroundColor = .secondarySystemBackground
        UISegmentedControl.appearance().backgroundColor = .clear
        model = AddTaskViewModel(task, project)
        keyboard = KeyboardResponder()
        self.moc = moc
    }

    var body: some View {
        VStack {
            titleBar()
            MObjectStatePicker(statusIndex: $model.statusIndex)
            Form {
                stepsSection()
                AddMObjectView(model: model)
            }
        }
        .padding(.bottom, keyboard.currentHeight)
        .sheet(isPresented: $model.showModal) {
            if (self.model.modalType == .notes) {
                NotesView(notes: self.$model.details, keyboard: self.keyboard)
            } else {
                Text("Add notification")
            }
        }

    }
    
    func stepsSection() -> some View {
        StepsView(model: model.stepsModel).onLongPressGesture {
            withAnimation {
                if self.editMode?.wrappedValue != .active {
                    self.editMode?.wrappedValue = .active
                }
                self.editVisible = true
            }
        }
    }
    

    func titleBar() -> some View {
        ModalTitle(title: model.task == nil ? "Add Task": "Edit Task", edit: editVisible) {
            let _ = MTask.createOrSync(from: self.model, context: self.moc, task: self.model.task, project: self.model.project)

            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
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
