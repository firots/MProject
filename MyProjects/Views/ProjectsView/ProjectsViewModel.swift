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
    @Published var predicate: NSPredicate?

    var projectFilterTypeNames: [String] = MObjectStatus.all.map( {$0.rawValue.capitalizingFirstLetter()} )
    
    private var cancellableSet: Set<AnyCancellable> = []
    


    private var filterProjectsPublisher: AnyPublisher<NSPredicate?, Never> {
        $projectFilter
            .map { projectFilter in
                if projectFilter == 0 {
                    return nil
                } else {
                    return NSPredicate(format: "status == %@", MObjectStatus.all[projectFilter - 1].rawValue)
                }
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        projectFilterTypeNames.insert("All", at: 0)
        
        filterProjectsPublisher
            .receive(on: RunLoop.main)
            .map {predicate in
                predicate
        }
        .assign(to: \.predicate, on: self)
        .store(in: &cancellableSet)
    }
    
}
