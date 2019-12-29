//
//  MyProjectsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct MyProjectsView: View {
    @ObservedObject var model = MyProjectsViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                AddProjectButton()
                Text("No projects so far.")
            }
            .navigationBarTitle("My Projects")
        }
        .sheet(isPresented: $model.showAddProject)  {
            AddProjectView()
        }
    }
}

struct MyProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        MyProjectsView()
    }
}
