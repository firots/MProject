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
            if model is AddTaskViewModel {
                repeatModeSection()
            }
            if model.status == .waiting {
                autoStartSection()
            }
            deadlineSection()
            notifications()
        }
    }

    var modelName: String {
        model is AddProjectViewModel ? "project" : "task"
    }
    
    func dueToggle() -> some View {
        HStack {
            CellImageView(systemName:"exclamationmark.circle.fill")
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Deadline")
                    .foregroundColor(model.showExpiredWarning ? Color(.systemRed): Color(.label))
            }
        }
    }
    
    func repeatModeSection() -> some View {
        let taskModel = model as! AddTaskViewModel
        return Section {
            HStack {
                CellImageView(systemName: "arrow.clockwise.circle.fill")
                Text("Repeat Mode")
                Spacer()
                Text("\(RepeatMode.names[taskModel.repeatModeConfiguration.repeatMode].capitalizingFirstLetter())")
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.trailing, 8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.model.modalType = .setRepeatMode
                self.model.showModal = true
            }
        }
    }
    
    func notifications() -> some View {
        NotificationsView(model: model.notificationsModel) {
            self.model.modalType = .addNotification
            self.model.showModal = true
        }
    }
    
    func deadlineSection() -> some View {
        Section {
            dueToggle()
            
            if model.hasDeadline {
                DateTimePicker(date: $model.deadline)
            }
        }
    }
    
    func autoStartSection() -> some View {
        Section() {
            autoStartToggle()
            if model.hasAutoStart {
                DateTimePicker(date: $model.autoStart)
            }
        }
    }
    
    func autoStartToggle() -> some View {
        HStack {
            CellImageView(systemName: "play.circle.fill")
            Toggle(isOn: $model.hasAutoStart.animation()) {
                Text("Auto Start")
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
