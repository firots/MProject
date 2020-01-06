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
    var moc: NSManagedObjectContext
    
    init(task: MTask?, project: MProject?, context moc: NSManagedObjectContext) {
        model = AddTaskViewModel(task, project)
        self.moc = moc
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            titleBar()
            Form {
                mainSection()
            }
        }
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.task == nil ? "Add Task": "Edit Task") {
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
    
    func mainSection() -> some View {
        Section {
            TextField("Name of your task", text: $model.name)
            
            TextField("Details about your task (optional)", text: $model.details)
            
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Set a deadline for this task")
            }
            
            if model.hasDeadline {
                DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .date) {
                    Text("Date")
                }.accentColor(.purple)
                
                DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .hourAndMinute) {
                    Text("Time")
                }.accentColor(.purple)
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddTaskView(task: nil, project: nil, context: moc)
    }
}
