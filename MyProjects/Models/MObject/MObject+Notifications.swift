//
//  MObject+Notifications.swift
//  MyProjects
//
//  Created by Firot on 14.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation


extension MObject {
    func resetNotificationsOnIOS(clearFireDate: Bool) {
        deleteNotificationsFromIOS(clearFireDate: clearFireDate)
        createNotificationsOnIOS()
    }
    
    func resyncNotifications() {
        for notification in notifications {
            notification.setNextFireDate()
        }
        resetNotificationsOnIOS(clearFireDate: false)
    }
    
    func deleteNotificationsFromIOS(clearFireDate: Bool) {
        for notification in notifications {
            notification.deleteFromIOS(clearFireDate: clearFireDate)
        }
    }
    
    func createNotificationsOnIOS() {
        for notification in notifications {
            notification.createOnIOSIfNear()
        }
    }
    
    func createActivationNotificationsOnIOS() {
        if let started = self.started {
            if started.daysPassed(from: Date()) < 1 {
                //create auto start notifications
            }
        }
    }
    
    func createDeadlineNotificationsOnIOS() {
        if let deadline = deadline {
            if deadline.daysPassed(from: Date()) < 1 {
                //create deadline notifications
            }
        }
    }
}
