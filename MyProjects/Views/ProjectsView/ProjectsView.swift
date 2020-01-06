//
//  MyProjectsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ProjectsView: View {
    @ObservedObject private var model = ProjectsViewModel()
    @Environment(\.managedObjectContext) private var moc
    
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
    
    private func projectFilter() -> some View {
        Picker(selection: $model.projectFilter, label: Text("Show")) {
            ForEach(0..<MProject.ProjectStatus.all.count + 1) { index in
                Text(self.model.projectFilterTypeNames[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    private func listProjects() -> some View {
        FilteredList(predicate: model.predicate) { (project: MProject) in
            self.projectCell(project)
        }
    }
    
    private func addButton() -> some View {
        AddButton() {
            self.model.showAddProject = true
        }
    }
    
    private func projectCell(_ project: MProject) -> some View {
        VStack(alignment: .leading) {
            Text(project.wrappedName)
            Text(project.wrappedDetails).font(.footnote)
            Text("Due: \(project.deadline?.toString() ?? "No Deadline")").font(.footnote)
        }
    }
}

struct MyProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
