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
        
    }
    
    func delete(id: UUID) {
        
    }
    
    func create(from model: MNotification) {
        guard let id = model.id else { return }
        guard let title = model.title, let date = model.nextFireDate else {
            delete(id: id)
            return
        }
        
        create(id: id, title: title, message: model.description, date: date)
    }
    
    func create(id: UUID, title: String, message: String, date: Date) {
        delete(id: id)
        
        
    }
    
}
