//
//  AddMObjectView.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddMObjectView: View {
    @ObservedObject var model: AddMObjectViewModel
    
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
            notificationsSection()
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
        .cornerRadius(8)
    }
    
    var modelName: String {
        model is AddProjectViewModel ? "project" : "task"
    }
    
    func dueToggle() -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(Color(.systemPurple))
                .aspectRatio(contentMode: .fill)
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Due")
            }
        }
    }
    
    func notificationsSection() -> some View {
        Section {
            Button(action: {
                withAnimation {
                    self.model.modalType = .addNotification
                    self.model.showModal = true
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Notification")
                }
            }.accentColor(Color(.systemPurple))
        }
    }
    
    func deadlineSection() -> some View {
        Section {
            dueToggle()
            
            if model.hasDeadline {
                dateTimePicker(date: $model.deadline)
            }
        }
        .modifier(DismissKeyboardOnTap())
    }
    
    func dateTimePicker(date: Binding<Date>) -> some View {
        Group {
            DatePicker(selection: date, in: Date()..., displayedComponents: .date) {
                Group {
                    Image(systemName: "calendar").foregroundColor(.clear)
                    Text("Date")
                }
            }
            .accentColor(Color(.systemPurple))

            DatePicker(selection: date, in: Date()..., displayedComponents: .hourAndMinute) {
                Group {
                    Image(systemName: "calendar").foregroundColor(.clear)
                    Text("Time")
                }
            }
            .accentColor(Color(.systemPurple))
        }
    }
    
    func autoStartSection() -> some View {
        Section {
            autoStartToggle()
            if model.showAutoStart {
                dateTimePicker(date: $model.autoStart)
            }
        }
        .modifier(DismissKeyboardOnTap())
    }
    
    func autoStartToggle() -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(Color(.systemPurple))
                .aspectRatio(contentMode: .fill)
            Toggle(isOn: $model.showAutoStart.animation()) {
                Text("Activation Date")
            }
        }
    }
    
    func mainSection() -> some View {
        Section {
            taskStatePicker()
            HStack {
                Image(systemName: "info.circle")
                .foregroundColor(Color(.systemPurple))
                .aspectRatio(contentMode: .fill)
                TextField("Name", text: $model.name)
            }.accentColor(Color(.systemPurple))

            Button(action: {
                self.model.modalType = .notes
                self.model.showModal = true
            }) {
                HStack {
                    Image(systemName: "pencil.circle")
                    .foregroundColor(Color(.systemPurple))
                    .aspectRatio(contentMode: .fill)
                    Text(self.model.details.emptyHolder("Details").noNewline())
                        .foregroundColor(Color(.placeholderText))
                        .lineLimit(1)
                }.accentColor(Color(.systemPurple))
            }
        }
    }
}

struct AddMObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMObjectView(model: AddMObjectViewModel(mObject: nil))
    }
}
