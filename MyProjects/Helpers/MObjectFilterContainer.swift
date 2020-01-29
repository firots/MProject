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
    var statusFilterTypeNames: [String] = MObjectStatus.names.map( {$0.capitalizingFirstLetter()} )
    
    @Published var sortBy: MObjectSortType
    @Published var ascending: Bool
    
    @Published var sortDescriptor: NSSortDescriptor
    
    @Published var dateFilter: MObjectDateFilterType
    @Published var statusFilter: Int
    
    @Published var statusPredicate: NSPredicate?
    @Published var datePredicate: NSPredicate?
    @Published var predicate: NSCompoundPredicate?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(project: MProject?, dateFilter: MObjectDateFilterType, statusFilter: Int, sortBy: MObjectSortType, ascending: Bool) {
        statusFilterTypeNames.insert("All", at: 0)
        self.dateFilter = dateFilter
        self.statusFilter = statusFilter
        self.sortBy = sortBy
        self.ascending = ascending
        self.project = project
        self.sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
        
        initFiltering()
        initSorting()
        
       
    }
}


/* Sorting */
extension MObjectFilterContainer {
    
    func initSorting() {
        sortByPublisher
            .receive(on: RunLoop.main)
            .map {sort in
                sort
        }
        .assign(to: \.sortBy, on: self)
        .store(in: &cancellableSet)
        
        ascendingPublisher
            .receive(on: RunLoop.main)
            .map {sort in
                sort
        }
        .assign(to: \.ascending, on: self)
        .store(in: &cancellableSet)
        
        sortDescriptorPublisher
            .receive(on: RunLoop.main)
            .map {sort in
                self.getSortDescriptor()
        }
        .assign(to: \.sortDescriptor, on: self)
        .store(in: &cancellableSet)
        
        self.sortDescriptor = getSortDescriptor()
    }
    
    private var sortByPublisher: AnyPublisher<MObjectSortType, Never> {
        $sortBy
            .map { sort in
                sort
            }
            .eraseToAnyPublisher()
    }
    
    private var ascendingPublisher: AnyPublisher<Bool, Never> {
        $ascending
            .map { asc in
                asc
            }
            .eraseToAnyPublisher()
    }
    
    private var sortDescriptorPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(sortByPublisher, ascendingPublisher)
            .map { sort, asc in
                true
        }
        .eraseToAnyPublisher()
    }
    
    private func getSortDescriptor() -> NSSortDescriptor {
        NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
    }
}




/* Filtering */
extension MObjectFilterContainer {
    func initFiltering() {
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
        
        predicatePublisher
            .receive(on: RunLoop.main)
            .map {p in
                self.combinePredicates()
        }
        .assign(to: \.predicate, on: self)
        .store(in: &cancellableSet)
        
        
        statusPredicate = getStatusPredicate(filter: statusFilter)
        datePredicate = getDatePredicate(from: dateFilter)
        predicate = combinePredicates()
    }
    
    
    func combinePredicates() -> NSCompoundPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, datePredicate].compactMap { $0 })
    }
    
    private var predicatePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(statusFilterPublisher, dateFilterPublisher)
            .map { status, date in
                true
        }
        .eraseToAnyPublisher()
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
            let interval = calendar.dateInterval(of: .day, for: Date())
            dateFrom = interval?.start
            dateTo = interval?.end
        case .week:
            let interval = calendar.dateInterval(of: .weekOfYear, for: Date())
            dateFrom = interval?.start
            dateTo = interval?.end
        case .month:
            let interval = calendar.dateInterval(of: .month, for: Date())
            dateFrom = interval?.start
            dateTo = interval?.end
        case .year:
            let interval = calendar.dateInterval(of: .year, for: Date())
            dateFrom = interval?.start
            dateTo = interval?.end
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
    case anytime
    case today
    case week
    case month
    case year
    
    static var all = [MObjectDateFilterType.anytime, MObjectDateFilterType.today, MObjectDateFilterType.week, MObjectDateFilterType.month, MObjectDateFilterType.year]
    static var names = ["All", "Today's", "This Week's", "This Month's", "This Year's"]
}

enum MObjectActionSheetType: Int {
    case sort
    case filter
}
    
enum MObjectSortType: String {
    case none
    case priority
    case name
    case created
    case started
    case deadline
    case status
    
    static let all = [MObjectSortType.none, MObjectSortType.priority, MObjectSortType.name, MObjectSortType.created, MObjectSortType.started, MObjectSortType.deadline]
    
    static var names = ["None", "Priority", "Name", "Date Created", "Date Started", "Deadline"]
}
