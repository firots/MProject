//
//  MObject+SyncNotifications.swift
//  MyProjects
//
//  Created by Firot on 20.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MObject {
    func clearNotifications(context moc: NSManagedObjectContext) {
        for notification in notifications {
            moc.delete(notification)
            //also delete from system
        }
    }
    
    func syncNotifications(with notificationModels: [AddNotificationViewModel], context moc: NSManagedObjectContext) {
        clearNotifications(context: moc)
        
        var notifications = [MNotification]()
        for notificationModel in notificationModels {
            let notification = MNotification.create(from: notificationModel, context: moc)
            if let task = self as? MTask {
                notification.task = task
            } else if let project = self as? MProject {
                notification.project = project
            }
            notifications.append(notification)
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
