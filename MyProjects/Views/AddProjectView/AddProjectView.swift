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
    @ObservedObject var model = AddProjectViewModel()
    var moc: NSManagedObjectContext
    
    var body: some View {
        VStack {
            Form {
                TextField("Name of your project", text: $model.name)
                
                TextField("Details about your project (optional)", text: $model.details)
                
                Toggle(isOn: $model.hasDeadline.animation()) {
                    Text("Project Deadline")
                }
                
                if model.hasDeadline {
                    DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .date) {
                        Text("Deadline")
                    }
                }

            }
            saveButton()
        }
    }
    
    func saveButton() -> some View {
        Button("Save") {
            let _ = MProject.create(from: self.model, context: self.moc)
            
            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    
    static var previews: some View {
        AddProjectView(moc: AddProjectView_Previews.moc)
    }
}
