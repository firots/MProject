//
//  TasksViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class TasksViewModel: MObjectsViewModel {
    @Published var showAdd = false
    @Published var showActionSheet = false
    @Published var filterContainer: MObjectFilterContainer
    @Published var showSortPopUp = false
    
    var fContainer: MObjectFilterContainer {
        get {
            return filterContainer
        } set {
            filterContainer = newValue
        }
    }
    
    var actionSheetType = MObjectActionSheetType.sort
    var modalType = ModalType.addTask
    var taskToEdit: MTask?
    let project: MProject?
    
    init(project: MProject?) {
        self.project = project
        filterContainer = MObjectFilterContainer(project: project, type: .task,
            dateFilter: project?.wrappedDateFilter.rawValue ?? Settings.shared.taskViewSettings.dateFilter,
            statusFilter: project?.statusFilter ?? Settings.shared.taskViewSettings.statusFilter,
            sortBy: project?.wrappedSortTasksBy ?? Settings.shared.taskViewSettings.sortBy,
            ascending: project?.tasksAscending ?? Settings.shared.taskViewSettings.ascending
        )
    }

    enum ModalType {
        case addTask
        case addProject
    }

}
