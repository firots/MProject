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
        self.model = AddProjectViewModel(mObject: project)
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            titleBar()
            Form {
                AddMObjectView(model: model)
            }
        }.navigationBarTitle("Add Project")
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.mObject == nil ? "Add Project": "Edit Project") {
            let _ = MProject.createOrSync(from: self.model, context: self.moc, project: self.model.mObject)

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
