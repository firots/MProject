//
//  AddProjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class AddProjectViewModel: ObservableObject {
    @Published var name = ""
    @Published var details = ""
    @Published var deadline = Date()
    @Published var hasDeadline = false
    
    var project: MProject?
    
    init(project: MProject?) {
        self.project = project
        if let p = project {
            sync(to: p)
        }
    }
    
    func sync(to project: MProject) {
        name = project.wrappedName
        details = project.wrappedDetails
        if let deadline = project.deadline {
            hasDeadline = true
            self.deadline = deadline
        }
    }
    
    /*private var cancellableSet: Set<AnyCancellable> = []
    
    private var hasDeadlinePublisher: AnyPublisher<Bool, Never> {
        $hasDeadline
            .map { hasDeadline in
                return hasDeadline
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        hasDeadlinePublisher
            .receive(on: RunLoop.main)
            .map {hasDeadline in
                hasDeadline ? self.deadline ?? Date() : nil
        }
        .assign(to: \.deadline, on: self)
        .store(in: &cancellableSet)
    }*/
    
    
}
