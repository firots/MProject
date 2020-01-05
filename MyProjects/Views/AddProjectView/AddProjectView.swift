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
    @ObservedObject var model: AddProjectViewModel
    var moc: NSManagedObjectContext
    
    init(context moc: NSManagedObjectContext, project: MProject?) {
        self.moc = moc
        self.model = AddProjectViewModel(project: project)
    }
    
    var body: some View {
        VStack {
            Form {
                mainSection()
            }
            saveButton()
        }
    }
    
    func mainSection() -> some View {
        Section {
            TextField("Name of your project", text: $model.name)
            
            TextField("Details about your project (optional)", text: $model.details)
            
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Set a deadline for this project")
            }
            
            if model.hasDeadline {
                DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .date) {
                    Text("Deadline")
                }.accentColor(.purple)
            }
        }
    }
    
    func saveButton() -> some View {
        Button("Save") {
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
        .foregroundColor(Color.white)
        .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
        .background(Color.purple)
        .clipShape(Capsule())
    }
}

struct AddProjectView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddProjectView(context: AddProjectView_Previews.moc, project: nil)
    }
}
