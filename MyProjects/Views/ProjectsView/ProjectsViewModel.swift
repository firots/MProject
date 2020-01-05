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
    @Published var projectFilter = 1
    @Published var showProjects = [MProject.ProjectStatus.active.rawValue]
    
    var projectFilterTypeNames: [String] = MProject.ProjectStatus.all.map( {$0.rawValue.capitalizingFirstLetter()} )
    
    private var cancellableSet: Set<AnyCancellable> = []

    
    private var showProjectsPublisher: AnyPublisher<[String], Never> {
        $projectFilter
            .map { projectFilter in
                if projectFilter == 0 {
                    return MProject.ProjectStatus.all.map({ $0.rawValue })
                } else {
                    return [MProject.ProjectStatus.all[projectFilter - 1].rawValue]
                }
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        projectFilterTypeNames.insert("All", at: 0)
        
        showProjectsPublisher
            .receive(on: RunLoop.main)
            .map {showProjects in
                showProjects
        }
        .assign(to: \.showProjects, on: self)
        .store(in: &cancellableSet)
    }
    
}
