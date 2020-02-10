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

class DataManager: Operation {
    private let context: NSManagedObjectContext

    var mObjectPredicate = NSPredicate(format: "status < %d", 2)
    var taksDeduplicatePredicate: NSPredicate? = nil
    var notificationPredicate = NSPredicate(format: "nextFireDate != nil")
    static var shared: DataManager?
    var text: String?
    var isViewContext: Bool
    
    init(isViewContext: Bool) {
        if isViewContext {
            context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
        } else {
            context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.newBackgroundContext()
        }
        self.isViewContext = isViewContext

        super.init()
    }
    
    init(context: NSManagedObjectContext, text: String) {
        self.isViewContext = false
        self.context = context
        self.text = text
    }
    
    func syncAll() {
        if isViewContext {
            self.syncTasks()
            self.syncProjects()
            self.syncNotifications()
            //LocalNotifications.shared.clearBastards(context: context)
        } else {
            context.performAndWait {
                self.syncTasks()
                self.syncProjects()
                self.syncNotifications()
                LocalNotifications.shared.clearBastards(context: context)
            }
        }

    }
    
    func syncNotifications() {
        let fetchRequest: NSFetchRequest<MNotification> = MNotification.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(MNotification.nextFireDate), ascending: true)
        
        fetchRequest.predicate = notificationPredicate
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 64
        
        do {
            var notifications = try context.fetch(fetchRequest)
            notifications.reverse()
            for notification in notifications {
                if isCancelled {
                    return
                }
                notification.createOnIOSIfNear(clearFireDate: true)
            }

        } catch {
            fatalError("Unable to fetch notifications.")
        }
    }

    override func main() {
        syncAll()
        
        if !self.isCancelled {
            if self.context.hasChanges {
                try? self.context.mSave()
            }
        }
        
        /*if text != nil {
            var now = Date()
            now.addMinutes(1)
            
            LocalNotifications.shared.create(id: UUID(), title: "syncAll called", message: "F: \(self.text ?? "no")", date: now)
        }*/

        
    }
    
    func syncTasks()  {
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = mObjectPredicate
        
        do {
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                task.update(self.context)
                if isCancelled {
                    return
                }
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
                project.update(context)
                if isCancelled {
                    return
                }
            }
        } catch {
            fatalError("Unable to fetch tasks.")
        }
    }
    

}
