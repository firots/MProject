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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    projectFilter()
                    listProjects()
                }
                
                addButton()
            }
            .navigationBarTitle("My Projects")
        }
        .sheet(isPresented: $model.showAddProject)  {
            AddProjectView(context: self.moc, project: nil)
        }
    }
    
    func projectFilter() -> some View {
        Picker(selection: $model.projectFilter, label: Text("Show")) {
            ForEach(0..<MProject.ProjectStatus.all.count + 1) { index in
                Text(self.model.projectFilterTypeNames[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    func listProjects() -> some View {
        FilteredProjectsList(predicate: model.predicate)
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
