//
//  MyProjectsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ProjectsView: View {
    @ObservedObject private var model: ProjectsViewModel
    @Environment(\.managedObjectContext) private var moc
    
    init() {
        model = ProjectsViewModel()
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(Date().toClassic()).padding(.leading, 20)
                    Spacer()
                }
                ZStack {
                    listProjects()
                    projectFilter()
                }
            }
            addButton()
        }
        .navigationBarTitle("My Projects")
        .sheet(isPresented: $model.showAddProject)  {
            AddProjectView(context: self.moc, project: nil)
        }
    }
    
    private func projectFilter() -> some View {
        VStack {
            Picker(selection: $model.projectFilter, label: Text("Show")) {
                ForEach(0..<MObjectStatus.all.count + 1) { index in
                    Text(self.model.projectFilterTypeNames[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemBackground))
            Spacer()
        }
    }
    
    private func listProjects() -> some View {
        FilteredList(predicate: model.predicate, placeholder: PlaceholderViewModel(title: MObjectStatus.emptyProjectTitles[model.projectFilter], subtitle: MObjectStatus.emptyProjectSubtitles[model.projectFilter], image: UIImage(named: "pencil"))) { (project: MProject) in
            self.projectCell(project)
        }
    }
    
    private func addButton() -> some View {
        VStack {
            Spacer()
            HoveringButton(color: Color(.systemPurple), image: Image(systemName: "plus")) {
                self.model.showAddProject = true
            }
        }
    }
    
    private func projectCell(_ project: MProject) -> some View {
        return NavigationLink(destination: TasksView(project: project)) {
            HStack {
                CircularProgressBarView(color: project.color, text: "\(project.progressPercentage)%", width: 60, thickness: 5, progress: project.wrappedProgress)
                VStack(alignment: .leading) {
                    Text(project.wrappedName)
                    Text(project.wrappedDetails).font(.footnote).lineLimit(1)
                    Text("Due: \(project.deadline?.toRelative() ?? "No Deadline")").font(.footnote)
                }
            }

        }
        .onAppear() {
            project.setProgress()
        }
        .listRowBackground(cellBackgroundColor)
    }
    
    private var cellBackgroundColor: Color {
        Color(.systemBackground)
    }
    
    private var cellColor: Color {
        Color(.systemBackground)
    }
}

struct MyProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
