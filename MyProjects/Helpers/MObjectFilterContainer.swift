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

struct MObjectFilterContainer {
    var dateFilter: MObjectDateFilterType
    var statusFilter: Int
    var sortBy: MObjectSortType
    var ascending: Bool
    var taskFilterTypeNames: [String] = MObjectStatus.names.map( {$0.capitalizingFirstLetter()} )
    
    var predicate: NSPredicate?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    init(dateFilter: MObjectDateFilterType, statusFilter: Int, sortBy: MObjectSortType, ascending: Bool) {
        taskFilterTypeNames.insert("All", at: 0)
        self.dateFilter = dateFilter
        self.statusFilter = statusFilter
        self.sortBy = sortBy
        self.ascending = ascending
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
