//
//  MObjectFilterContainer.swift
//  MyProjects
//
//  Created by Firot on 28.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine
import CoreData

class MObjectFilterContainer: ObservableObject {
    var project: MProject?
    
    @Published var dateFilter: MObjectDateFilterType
    @Published var statusFilter: Int
    @Published var sortBy: MObjectSortType
    @Published var ascending: Bool
    var statusFilterTypeNames: [String] = MObjectStatus.names.map( {$0.capitalizingFirstLetter()} )
    
    @Published var predicate: NSPredicate?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    init(project: MProject?, dateFilter: MObjectDateFilterType, statusFilter: Int, sortBy: MObjectSortType, ascending: Bool) {
        statusFilterTypeNames.insert("All", at: 0)
        self.dateFilter = dateFilter
        self.statusFilter = statusFilter
        self.sortBy = sortBy
        self.ascending = ascending
        self.project = project
        
        filterPublisher
            .receive(on: RunLoop.main)
            .map {predicate in
                predicate
        }
        .assign(to: \.predicate, on: self)
        .store(in: &cancellableSet)
        
        predicate = getPredicate(filter: statusFilter)
    }
    
    private var filterPublisher: AnyPublisher<NSPredicate?, Never> {
        $statusFilter
            .map { taskFilter in
                self.project?.stateFilter = taskFilter
                return self.getPredicate(filter: taskFilter)
            }
            .eraseToAnyPublisher()
    }
    
    
    func getPredicate(filter: Int) -> NSPredicate? {
        if filter == 0 {
            if self.project == nil {
                return nil
            } else {
                return NSPredicate(format: "project == %@", self.project!)
            }
        } else {
            if self.project == nil {
                return NSPredicate(format: "status == %d", MObjectStatus.all[filter - 1].rawValue)
            } else {
                return NSPredicate(format: "status == %d AND project == %@", MObjectStatus.all[filter - 1].rawValue, self.project!)
            }
        }
    }
    
    
    
    
}

enum MObjectDateFilterType: Int {
    case all
    case today
    case week
    case month
}

enum MObjectActionSheetType: Int {
    case sort
    case filter
}
    
enum MObjectSortType: Int {
    case none
    case priority
    case alphabetic
    case creation
    case started
    case deadline
    case status
    
    static let all = [MObjectSortType.none, MObjectSortType.priority, MObjectSortType.alphabetic, MObjectSortType.creation, MObjectSortType.started, MObjectSortType.deadline]
    
    static var names = ["None", "Priority", "Alphabetic", "Date Created", "Date Started", "Deadline"]
}
