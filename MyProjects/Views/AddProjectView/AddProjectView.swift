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
            saveButton()
        }
    }
    
    func saveButton() -> some View {
        Button("Save") {
            let project = MProject(context: self.moc)
            project.id = UUID()
            project.name = "Test Project"
            
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
