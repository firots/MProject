//
//  AddProjectView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct AddProjectView: View {
    @ObservedObject var model = AddTaskViewModel()
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        saveButton()
    }
    
    func saveButton() -> some View {
        Button("Save") {
            if self.moc.hasChanges { try? self.moc.save() }
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
