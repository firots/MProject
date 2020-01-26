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
    var notificationPredicate = NSPredicate(format: "nextFireDate != nil")
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func syncAll() {
        DispatchQueue.main.async {
            self.syncTasks()
            self.syncProjects()
            self.syncNotifications()
            
            if self.context.hasChanges {
                try? self.context.save()
            }
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
        LocalNotifications.shared.deleteAll()
        let fetchRequest: NSFetchRequest<MNotification> = MNotification.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(MNotification.nextFireDate), ascending: true)
        
        fetchRequest.predicate = notificationPredicate
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 32
        
        do {
            let notifications = try context.fetch(fetchRequest)
            for notification in notifications {
                notification.createOnIOSIfNear()
            }

        } catch {
            fatalError("Unable to fetch notifications.")
        }
        
        
    }
    
    func rescheduleNotifications() {
        
    }
    
    
}
