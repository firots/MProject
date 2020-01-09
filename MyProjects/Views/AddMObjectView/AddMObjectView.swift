//
//  AddMObjectView.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddMObjectView: View {
    @ObservedObject private var model: AddMObjectViewModel
    
    init(model: AddMObjectViewModel) {
        self.model = model
    }
    
    var body: some View {
        Group {
            mainSection()
            deadlineSection()
            if model.status == .waiting {
                autoStartSection()
            }
        }
    }
    
    private func taskStatePicker() -> some View {
        Picker(selection: $model.statusIndex.animation(), label: Text("Status")) {
            ForEach(0..<MObjectStatus.all.count) { index in
                Text(MObjectStatus.all[index].rawValue.capitalizingFirstLetter())
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(MObjectStatus.colors[model.statusIndex])
        .cornerRadius(5)
    }
    
    var modelName: String {
        model is AddProjectViewModel ? "project" : "task"
    }
    
    func dueToggle() -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(Color(.purple))
                .aspectRatio(contentMode: .fill)
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Due date")
            }
        }
    }
    
    func deadlineSection() -> some View {
        Section {
            dueToggle()
            
            if model.hasDeadline {
                dateTimePicker(date: $model.deadline)
            }
        }
    }
    
    func dateTimePicker(date: Binding<Date>) -> some View {
        Group {
            DatePicker(selection: date, in: Date()..., displayedComponents: .date) {
                Text("Date")
            }
            .accentColor(.purple)
            .modifier(DismissKeyboardOnTap())
            
            DatePicker(selection: date, in: Date()..., displayedComponents: .hourAndMinute) {
                Text("Time")
            }
            .accentColor(.purple)
            .modifier(DismissKeyboardOnTap())
        }
    }
    
    func autoStartSection() -> some View {
        Section {
            autoStartToggle()
            if model.showAutoStart {
                dateTimePicker(date: $model.autoStart)
            }
        }
    }
    
    func autoStartToggle() -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(Color(.purple))
                .aspectRatio(contentMode: .fill)
            Toggle(isOn: $model.showAutoStart.animation()) {
                Text("Automatic Activation")
            }
        }
    }
    
    func mainSection() -> some View {
        Section {
            taskStatePicker()
            HStack {
                Image(systemName: "info.circle")
                .foregroundColor(Color(.purple))
                .aspectRatio(contentMode: .fill)
                TextField("Name", text: $model.name)
            }.accentColor(.purple)

            Button(action: {
                self.model.showNotes = true
            }) {
                HStack {
                    Image(systemName: "pencil.circle")
                    .foregroundColor(Color(.purple))
                    .aspectRatio(contentMode: .fill)
                    Text(self.model.details.emptyHolder("Details"))
                        .foregroundColor(Color(.tertiaryLabel))
                        .lineLimit(1)
                }.accentColor(.purple)
            }
        }
    }
}

struct AddMObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMObjectView(model: AddMObjectViewModel(mObject: nil))
    }
}
