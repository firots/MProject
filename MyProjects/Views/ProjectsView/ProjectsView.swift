//
//  MyProjectsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ProjectsView: View, MObjectLister  {
    @ObservedObject var model: ProjectsViewModel
    @Environment(\.managedObjectContext) private var moc
    
    init() {
        model = ProjectsViewModel()
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(Date().toClassic()).padding(.leading, 22)
                    Spacer()
                }
                ZStack {
                    listProjects()
                    projectFilter()
                }
            }
            addButton()
        }
        .navigationBarItems(trailing: MObjectSortButtons(hasEdit: false, hasDetails: false, ascending: $model.filterContainer.ascending, editMode: $model.multiSelection, showDetails: $model.showDetails, sortAction: {
            self.sortButtonAction()
        }, filterAction: {
            self.filterButtonAction()
        })
            .popover(isPresented: $model.showSortPopUp) {
                self.sortPopOver()
            }
        )
        .navigationBarTitle(MObjectDateFilterType.names[model.filterContainer.dateFilter])
        .sheet(isPresented: $model.showAddProject)  {
            if Settings.shared.pro == false && self.moc.hasProjectLimitReached() {
                PurchaseView()
            } else {
                AddProjectView(context: self.moc, project: nil)
            }
        }
        .actionSheet(isPresented: $model.showActionSheet) {
            actionSheet()
        }.onDisappear() {
            //self.model.filterContainer.savePreferences()
        }.onAppear() {
            //MObjectFilterContainer.latestInstance = self.model.filterContainer
        }
    }
    
    private func projectFilter() -> some View {
        VStack {
            Picker(selection: $model.filterContainer.statusFilter, label: Text("Show")) {
                ForEach(0..<MObjectStatus.all.count + 1) { index in
                    Text(self.model.filterContainer.statusFilterTypeNames[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemBackground))
            
            if UIDevice.current.userInterfaceIdiom != .phone {
                dateFilter()
            }
            
            Spacer()
        }
    }
    
    private func dateFilter() -> some View {
        VStack {
            Picker(selection: $model.filterContainer.dateFilter, label: Text("Show")) {
                ForEach(0..<MObjectDateFilterType.all.count) { index in
                    Text(MObjectDateFilterType.shortNames[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemBackground))
            Spacer()
        }
    }
    
    private func listProjects() -> some View {
        FilteredList(listID: model.filterContainer.listID, predicate: model.filterContainer.predicate, sorter: model.filterContainer.sortDescriptor, placeholder: PlaceholderViewModel(title: MObjectStatus.emptyProjectTitles[model.filterContainer.statusFilter], subtitle: MObjectStatus.emptyProjectSubtitles[model.filterContainer.statusFilter], image: UIImage(named: "pencil"))) { (project: MProject) in
            self.projectCell(project)
        }.padding(.top, topPadding)
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
        ProjectCellView(project: project)
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
