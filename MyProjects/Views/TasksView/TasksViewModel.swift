//
//  TasksViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class TasksViewModel: ObservableObject {
    @Published var showAdd = false
    @Published var showActionSheet = false
    @Published var filterContainer: MObjectFilterContainer
    
    var actionSheetType = MObjectActionSheetType.sort
    var modalType = ModalType.addTask
    var taskToEdit: MTask?
    let project: MProject?
    
    init(project: MProject?) {
        self.project = project
        filterContainer = MObjectFilterContainer(project: project, dateFilter: MObjectDateFilterType.anytime, statusFilter: 0, sortBy: .none, ascending: true)

    }

    enum ModalType {
        case addTask
        case addProject
    }

}
