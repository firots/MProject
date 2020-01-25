//
//  LocalNotifications.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class LocalNotifications {
    
    static let shared = LocalNotifications()
    
    private init() {
        
    }
    
    func deleteAll() {
        print("DELETE ALL NOTIFICATIONS")
    }
    
    func delete(id: UUID) {
        print("DELETE FROM IOS")
    }
    
    func create(from model: MNotification) {
        print("CREATE ON IOS FROM MODEL")
        guard let id = model.id else { return }
        guard let title = model.title, let date = model.nextFireDate else { return }
        create(id: id, title: title, message: model.description, date: date)
    }
    
    func create(id: UUID, title: String, message: String, date: Date) {
        print("CREATED ON IOS \(date.toRelative())")
        
        
    }
    
}
