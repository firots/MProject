//
//  MObjectManager.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class DataManager {
    static let shared = DataManager()
    private let context: NSManagedObjectContext

    var mObjectPredicate = NSPredicate(format: "status < %d", 2)
    var notificationPredicate = NSPredicate(format: "date != nil")
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func syncAll() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.syncTasks()
            self.syncProjects()
            self.syncNotifications()
        }
    }
    
    func syncTasks()  {
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = mObjectPredicate
        
        do {
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                task.update()
            }
        } catch {
            fatalError("Unable to fetch tasks.")
        }
    }
    
    func syncProjects() {
        let fetchRequest: NSFetchRequest<MProject> = MProject.fetchRequest()
        fetchRequest.predicate = mObjectPredicate
        
        do {
            let projects = try context.fetch(fetchRequest)
            for project in projects {
                project.update()
            }
        } catch {
            fatalError("Unable to fetch tasks.")
        }
    }
    
    func syncNotifications() {
        let fetchRequest: NSFetchRequest<MNotification> = MNotification.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(MNotification.nextFireDate), ascending: true)
        
        fetchRequest.predicate = notificationPredicate
        fetchRequest.sortDescriptors = [sort]

        do {
            let notifications = try context.fetch(fetchRequest)
            for notification in notifications {
                print(notification.nextFireDate?.toRelative())
            }
        } catch {
            fatalError("Unable to fetch notifications.")
        }
        
        
    }
    
    func rescheduleNotifications() {
        
    }
    
    
}
