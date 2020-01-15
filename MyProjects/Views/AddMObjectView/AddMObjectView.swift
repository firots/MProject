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
            if model.status == .waiting {
                autoStartSection()
            }
            deadlineSection()
            notificationsSection()
        }
    }

    var modelName: String {
        model is AddProjectViewModel ? "project" : "task"
    }
    
    func dueToggle() -> some View {
        HStack {
            CellImageView(systemName:"calendar.circle.fill")
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Due")
            }
        }
    }
    
    func notificationsSection() -> some View {
        Section {
            HStack {
                CellImageView(systemName: "plus.circle.fill")
                Text("Add Notification")
                .foregroundColor(Color(.systemPurple))
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.model.modalType = .addNotification
                    self.model.showModal = true
                }
            }
            
        }.accentColor(Color(.systemPurple))
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
                Group {
                    Spacer().frame(width: 37)
                    Text("Date")
                }
            }
            .accentColor(Color(.systemPurple))

            DatePicker(selection: date, in: Date()..., displayedComponents: .hourAndMinute) {
                Group {
                    Spacer().frame(width: 37)
                    Text("Time")
                }
            }
            .accentColor(Color(.systemPurple))
        }
    }
    
    func autoStartSection() -> some View {
        Section {
            autoStartToggle()
            if model.hasAutoStart {
                dateTimePicker(date: $model.autoStart)
            }
        }
    }
    
    func autoStartToggle() -> some View {
        HStack {
            CellImageView(systemName: "calendar.circle.fill")
            Toggle(isOn: $model.hasAutoStart.animation()) {
                Text("Activation Date")
            }
        }
    }
    
    func mainSection() -> some View {
        Section {
            HStack {
                CellImageView(systemName: "info.circle.fill")
                TextField("\(modelName.capitalizingFirstLetter()) Name", text: $model.name)
                }.accentColor(Color(.systemPurple))

            detailsButton()
        }
    }
    
    func detailsButton() -> some View {
        HStack {
            CellImageView(systemName: "pencil.circle.fill")
            Text(self.model.details.emptyHolder("Details"))
                .foregroundColor(Color(.placeholderText))
                .lineLimit(3)
            Spacer()
        }.accentColor(Color(.systemPurple))
        .contentShape(Rectangle())
        .onTapGesture {
            self.model.modalType = .notes
            self.model.showModal = true
        }
    }
}


struct AddMObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMObjectView(model: AddMObjectViewModel(mObject: nil))
    }
}
