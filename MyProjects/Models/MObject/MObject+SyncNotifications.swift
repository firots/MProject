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
        deleteNotificationsFromIOS(clearFireDate: true)
        for notification in notifications {
            moc.delete(notification)
        }
    }
    
    func syncNotifications(with notificationModels: [AddNotificationViewModel], context moc: NSManagedObjectContext) {
        var editedOrNewNotifications = [MNotification]()
        var notificationsToDelete = notifications
        for notificationModel in notificationModels {
            let notification = MNotification.createOrSync(from: notificationModel, context: moc)
            if let task = self as? MTask {
                notification.task = task
            } else if let project = self as? MProject {
                notification.project = project
            }
            editedOrNewNotifications.append(notification)
            notificationsToDelete.removeAll(where: { $0.wrappedID == notificationModel.id })
        }
        
        for deletedNotification in notificationsToDelete {
            deletedNotification.deleteFromIOS(clearFireDate: true)
            moc.delete(deletedNotification)
        }
        
        if moc.hasChanges {
            try? moc.mSave()
        }
    }
}
