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
    
    var type: MObjectType
    
    static weak var latestInstance: MObjectFilterContainer?
    
    @Published var sortBy: MObjectSortType { didSet {  savePreferences() } }
    @Published var ascending: Bool { didSet {  savePreferences() } }
    
    @Published var sortDescriptor: NSSortDescriptor
    
    @Published var dateFilter: Int { didSet {  savePreferences() } }
    @Published var statusFilter: Int { didSet {  savePreferences() } }
    
    @Published var statusPredicate: NSPredicate?
    @Published var datePredicate: NSPredicate?
    @Published var predicate: NSCompoundPredicate?
    
    @Published var showDetails: Bool { didSet {  savePreferences() } }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(project: MProject?, type: MObjectType, dateFilter: Int, statusFilter: Int, sortBy: MObjectSortType, ascending: Bool, showDetails: Bool) {
        statusFilterTypeNames.insert("All", at: 0)
        self.dateFilter = dateFilter
        self.statusFilter = statusFilter
        self.sortBy = sortBy
        self.ascending = ascending
        self.project = project
        self.type = type
        self.showDetails = showDetails
        self.sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
        
        initFiltering()
        initSorting()
    }
}


/* Sorting */
extension MObjectFilterContainer {
    func initSorting() {
        sortDescriptorPublisher
            .receive(on: RunLoop.main)
            .map { sort in
                sort
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
    
    private func saveShowDetails(value: Bool) {
        if self.type == .task {
            if let project = self.project, project.showTaskDetails != value {
                project.showTaskDetails = value
            } else {
                Settings.shared.taskViewSettings.showDetails = value
            }
        }
    }
    
    private func saveSortBy(value: MObjectSortType) {
        if self.type == .task {
            if let project = self.project, project.sortTasksBy != value.rawValue {
                project.sortTasksBy = value.rawValue
            } else {
                Settings.shared.taskViewSettings.sortBy = value
            }
        } else {
            Settings.shared.projectsViewSettings.sortBy = value
        }
    }
    
    private var ascendingPublisher: AnyPublisher<Bool, Never> {
        $ascending
            .map { asc in
                asc
            }
            .eraseToAnyPublisher()
    }
    
    private func saveAscending(value: Bool) {
        if type == .task {
            if let project = self.project, project.tasksAscending != value {
                project.tasksAscending = value
            } else {
                Settings.shared.taskViewSettings.ascending = value
            }
        } else {
            Settings.shared.projectsViewSettings.ascending = value
        }
    }
    
    private var sortDescriptorPublisher: AnyPublisher<NSSortDescriptor, Never> {
        Publishers.CombineLatest(sortByPublisher, ascendingPublisher)
            .map { sort, asc in
                self.sortBy = sort
                self.ascending = asc
                return self.getSortDescriptor()
        }
        .eraseToAnyPublisher()
    }
    
    private func getSortDescriptor() -> NSSortDescriptor {
        if sortBy == .name {
            return NSSortDescriptor(key: sortBy.rawValue, ascending: ascending, selector: #selector(NSString.caseInsensitiveCompare))
        }
        return NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
    }
    
    public func savePreferences() {
        self.saveStatusfilter(value: statusFilter)
        self.saveDateFilter(value: dateFilter)
        self.saveAscending(value: ascending)
        self.saveSortBy(value: sortBy)
        self.saveShowDetails(value: showDetails)
        
        DispatchQueue.main.async {
            if let project = self.project {
                if project.managedObjectContext?.hasChanges == true {
                    try? project.managedObjectContext?.save()
                }
            }
        }

    }
}

/* Filtering */
extension MObjectFilterContainer {
    func initFiltering() {
        predicatePublisher
            .receive(on: RunLoop.main)
            .map {compundPreticate in
                compundPreticate
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
    
    private var predicatePublisher: AnyPublisher<NSCompoundPredicate, Never> {
        Publishers.CombineLatest(statusFilterPublisher, dateFilterPublisher)
            .map { status, date in
                self.statusPredicate = status
                self.datePredicate = date
                return self.combinePredicates()
        }
        .eraseToAnyPublisher()
    }
}

/* Object Status Filter Publishers */
extension MObjectFilterContainer {
    private var statusFilterPublisher: AnyPublisher<NSPredicate?, Never> {
        $statusFilter
            .map { taskFilter in
                self.getStatusPredicate(filter: taskFilter)
            }
            .eraseToAnyPublisher()
    }
    
    private func saveStatusfilter(value: Int) {
        if type == .task {
            if let project = project, project.statusFilter != value {
                project.statusFilter = value
            } else {
                Settings.shared.taskViewSettings.statusFilter = value
            }
        } else {
            Settings.shared.projectsViewSettings.statusFilter = value
        }
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
                self.getDatePredicate(from: dateFilter)
            }
            .eraseToAnyPublisher()
    }
    
    private func saveDateFilter(value: Int) {
        if self.type == .task {
            if let project = project, project.dateFilter != value {
                project.dateFilter = value
            } else {
                Settings.shared.taskViewSettings.dateFilter = value
            }
        } else {
            Settings.shared.projectsViewSettings.dateFilter = value
        }
    }
    
    private func getDatePredicate(from filter: Int) -> NSPredicate? {
        let calendar = Calendar.current
        var dateFrom: Date?
        var dateTo: Date?
        let filter = MObjectDateFilterType(rawValue: filter) ?? MObjectDateFilterType.anytime
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
        NSPredicate(format: "(started >= %@) AND (started <= %@) OR (deadline >= %@) AND (deadline <= %@)", from as NSDate, to as NSDate, from as NSDate, to as NSDate)
    }
}




public enum MObjectDateFilterType: Int {
    case anytime
    case today
    case week
    case month
    case year
    
    static var all = [MObjectDateFilterType.anytime, MObjectDateFilterType.today, MObjectDateFilterType.week, MObjectDateFilterType.month, MObjectDateFilterType.year]
    static var names = ["Anytime", "Today", "This Week", "This Month", "This Year"]
    static var shortNames = ["Anytime", "Today", "This W", "This M", "This Y"]
}

public enum MObjectActionSheetType: Int {
    case sort
    case filter
}
    
public enum MObjectSortType: String {
    case none
    case priority
    case name
    case created
    case started
    case deadline
    case status
    case lastModified
    
    static let all = [MObjectSortType.none, MObjectSortType.priority, MObjectSortType.name, MObjectSortType.status, MObjectSortType.created, MObjectSortType.lastModified, MObjectSortType.started, MObjectSortType.deadline]
    
    static var names = ["None", "Priority", "Name", "Status", "Date Created", "Date Modified", "Date Started", "Deadline"]
}
