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
    var moc: NSManagedObjectContext
    
    init(context moc: NSManagedObjectContext, project: MProject?) {
        UITableView.appearance().backgroundColor = .secondarySystemBackground
        UISegmentedControl.appearance().backgroundColor = .clear
        self.moc = moc
        self.model = AddProjectViewModel(project: project)
    }
    
    var body: some View {
        VStack {
            titleBar()
            Form {
                AddMObjectView(model: model)
            }
        }
        .sheet(isPresented: $model.showModal) {
            if (self.model.modalType == .notes) {
                NotesView(model: NotesViewModel(notes: self.$model.details))
            } else {
                Text("Add notification")
            }
        }
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.project == nil ? "Add Project": "Edit Project") {
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
