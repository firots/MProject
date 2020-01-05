//
//  MyProjectsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ProjectsView: View {
    @ObservedObject var model = ProjectsViewModel()
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: MProject.entity(), sortDescriptors: []) var projects: FetchedResults<MProject>
    
    var body: some View {
        NavigationView {
            ZStack {
                listProjects()
                addButton()
            }
            .navigationBarTitle("My Projects")
        }
        .sheet(isPresented: $model.showAddProject)  {
            AddProjectView(moc: self.moc)
        }
    }
    
    func listProjects() -> some View {
        List(projects, id: \.self) { project in
            Text(project.wrappedName)
            Text(project.wrappedDetails)
        }
    }
    
    func addButton() -> some View {
        AddButton() {
            self.model.showAddProject = true
        }
    }
}

struct MyProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
