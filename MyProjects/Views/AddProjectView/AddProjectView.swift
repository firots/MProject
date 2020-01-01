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
    
    var body: some View {
        Text("Add Project")
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
