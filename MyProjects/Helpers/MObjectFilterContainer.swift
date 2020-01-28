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
    
    @Published var statusPredicate: NSPredicate? {
        didSet {
            setPredicate()
        }
    }
    @Published var datePredicate: NSPredicate? {
        didSet {
            setPredicate()
        }
    }
    @Published var predicate: NSCompoundPredicate?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(project: MProject?, dateFilter: MObjectDateFilterType, statusFilter: Int, sortBy: MObjectSortType, ascending: Bool) {
        statusFilterTypeNames.insert("All", at: 0)
        self.dateFilter = dateFilter
        self.statusFilter = statusFilter
        self.sortBy = sortBy
        self.ascending = ascending
        self.project = project
        
        statusFilterPublisher
            .receive(on: RunLoop.main)
            .map {predicate in
                predicate
        }
        .assign(to: \.statusPredicate, on: self)
        .store(in: &cancellableSet)
        
        
        dateFilterPublisher
            .receive(on: RunLoop.main)
            .map {predicate in
                predicate
        }
        .assign(to: \.datePredicate, on: self)
        .store(in: &cancellableSet)
        
        
        statusPredicate = getStatusPredicate(filter: statusFilter)
        
        datePredicate = getDatePredicate(from: dateFilter)
    }
    
    func setPredicate() {
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate ?? NSPredicate(format: "id != %@", UUID().uuidString), datePredicate ?? NSPredicate(format: "id != %@", UUID().uuidString)])
    }
    

}

/* Object Status Filter Publishers */
extension MObjectFilterContainer {
    private var statusFilterPublisher: AnyPublisher<NSPredicate?, Never> {
        $statusFilter
            .map { taskFilter in
                self.project?.stateFilter = taskFilter
                /* to do: set settings main task state filter here */
                return self.getStatusPredicate(filter: taskFilter)
            }
            .eraseToAnyPublisher()
    }
    
    private func getStatusPredicate(filter: Int) -> NSPredicate? {
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

/* Date Filter Publishers */
extension MObjectFilterContainer {
    private var dateFilterPublisher: AnyPublisher<NSPredicate?, Never> {
        $dateFilter
            .map { dateFilter in
                /* to do: set settings main task date filter here and projedt date filrer */
                self.getDatePredicate(from: dateFilter)
            }
            .eraseToAnyPublisher()
    }
    
    private func getDatePredicate(from filter: MObjectDateFilterType) -> NSPredicate? {
        let calendar = Calendar.current
        var dateFrom: Date?
        var dateTo: Date?
        switch filter {
        case .today:
            dateFrom = calendar.startOfDay(for: Date())
            dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom!)
        case .week:
            dateFrom = Date().withFirstDayOfWeek().withZeroHourAndMinutes()
            dateTo = calendar.date(byAdding: .day, value: 7, to: dateFrom!)
        case .month:
            dateFrom = Date().withFirstDayOfMonth().withZeroHourAndMinutes()
            dateTo = calendar.date(byAdding: .day, value: 30, to: dateFrom!)
        default:
            dateTo = nil
            dateFrom = nil
        }
        
        guard let from = dateFrom, let to = dateTo else { return nil }
        
        return dateBetweenPredicate(from, to)
    }
    
    private func dateBetweenPredicate(_ from: Date, _ to: Date) -> NSPredicate? {
        NSPredicate(format: "(started >= %@) AND (started <= %@)", from as NSDate, to as NSDate)
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
