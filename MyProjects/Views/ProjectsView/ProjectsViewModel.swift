//
//  MyProjectsViewModel.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import Foundation
import Combine

class ProjectsViewModel: ObservableObject {
    @Published var showAddProject = false
    @Published var filterContainer: MObjectFilterContainer

    init() {
        filterContainer = MObjectFilterContainer(project: nil, dateFilter: MObjectDateFilterType.anytime, statusFilter: 0, sortBy: .none, ascending: true)
    }
}
