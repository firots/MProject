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
            AddProjectView(context: self.moc, project: nil)
        }
    }
    
    func listProjects() -> some View {
        List {
            ForEach(projects, id: \.self) { project in
                HStack {
                    VStack(alignment: .leading) {
                        Text(project.wrappedName)
                        Text(project.wrappedDetails).font(.footnote)
                        Text("Due: \(project.deadline?.toString() ?? "No Deadline")").font(.footnote)
                        
                    }
                    Spacer()
                }

            }.onDelete(perform: removeProjects)
        }
    }
    
    func addButton() -> some View {
        AddButton() {
            self.model.showAddProject = true
        }
    }
    
    func removeProjects(at offsets: IndexSet) {
        for index in offsets {
            let project = projects[index]
            moc.delete(project)
        }
        if moc.hasChanges { try? moc.save() }
    }
}

struct MyProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
