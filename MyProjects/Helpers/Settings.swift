//
//  Settings.swift
//  MyProjects
//
//  Created by Firot on 29.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class Settings: ObservableObject, Codable {
    var taskViewSettings: TasksViewSettings
    var projectsViewSettings: TasksViewSettings
    
    init() {
        taskViewSettings = TasksViewSettings()
        projectsViewSettings = TasksViewSettings()
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: "Settings")
        }
    }
    
    static var shared = Settings()
    
    static func load() {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "Settings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(Settings.self, from: savedSettings) {
                Settings.shared = loadedSettings
                
                print(loadedSettings.taskViewSettings.statusFilter)
            }
        }
    }

}

struct TasksViewSettings: Codable {
    var dateFilter = MObjectDateFilterType.anytime
    var statusFilter = 0
    
    var sortBy = MObjectSortType.created
    var ascending = false
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dateFilter = try MObjectDateFilterType(rawValue: container.decode(Int.self, forKey: .dateFilter)) ?? MObjectDateFilterType.anytime
        sortBy = try MObjectSortType(rawValue: container.decode(String.self, forKey: .sortBy)) ?? MObjectSortType.created
        statusFilter =  try container.decode(Int.self, forKey: .statusFilter)
        ascending =  try container.decode(Bool.self, forKey: .ascending)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dateFilter.rawValue, forKey: .dateFilter)
        try container.encode(statusFilter, forKey: .statusFilter)
        try container.encode(sortBy.rawValue, forKey: .sortBy)
        try container.encode(ascending, forKey: .ascending)
        
    }
    
    enum CodingKeys: CodingKey {
        case dateFilter
        case statusFilter
        case sortBy
        case ascending
       
    }
}


