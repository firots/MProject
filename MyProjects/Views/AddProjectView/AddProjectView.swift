//
//  AddProjectView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI
import CoreData

struct AddProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var model: AddProjectViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
    var moc: NSManagedObjectContext
    
    init(context moc: NSManagedObjectContext, project: MProject?) {
        self.moc = moc
        self.model = AddProjectViewModel(project: project)
    }
    
    var body: some View {
        VStack {
            titleBar()
            MObjectStatePicker(statusIndex: $model.statusIndex)
        
            ZStack {
                Form {
                    AddMObjectView(model: model)
                }
                
                expiredText()
            }.padding(.bottom, keyboard.currentHeight)
            .background(Color(.systemGroupedBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        
        .sheet(isPresented: $model.showModal) {
            if (self.model.modalType == .notes) {
                NotesView(notes: self.$model.details, keyboard: self.keyboard)
            } else {
                AddNotificationView(notification: self.model.notificationsModel.notificationToAdd, keyboard: self.keyboard, isNew: self.model.notificationsModel.isNew) {
                    self.model.notificationsModel.notifications.append(self.model.notificationsModel.notificationToAdd)
                }
            }
        }
    }
    
    func expiredText() -> some View {
        TopWarningView(text: "This project will fail, please change or disable the deadline.", show: model.showExpiredWarning)
            .animation(.easeInOut)
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.project == nil ? "Add New Project": "Edit Project", edit: false) {
            let _ = MProject.createOrSync(from: self.model, context: self.moc, project: self.model.project)

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

struct AddProjectView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddProjectView(context: AddProjectView_Previews.moc, project: nil)
    }
}
