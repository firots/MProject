//
//  MyProjectsViewModel.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import Foundation
import Combine

class ProjectsViewModel: MObjectsViewModel {
    @Published var showAddProject = false
    @Published var showActionSheet = false
    @Published var filterContainer: MObjectFilterContainer
    @Published var showSortPopUp = false
    
    var actionSheetType = MObjectActionSheetType.sort
    
    var fContainer: MObjectFilterContainer {
        get {
            return filterContainer
        } set {
            filterContainer = newValue
        }
    }

    init() {
        filterContainer = MObjectFilterContainer(project: nil, type: .project, dateFilter: Settings.shared.projectsViewSettings.dateFilter, statusFilter: Settings.shared.projectsViewSettings.statusFilter, sortBy: Settings.shared.projectsViewSettings.sortBy, ascending: Settings.shared.projectsViewSettings.ascending)
    }
}
