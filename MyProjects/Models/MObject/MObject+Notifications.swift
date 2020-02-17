//
//  MObject+Notifications.swift
//  MyProjects
//
//  Created by Firot on 14.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation


extension MObject {
    func resyncNotifications() {
        for notification in notifications {
            notification.setNextFireDate(skipNow: true)
        }
        createNotificationsOnIOS()
    }
    
    func deleteNotificationsFromIOS(clearFireDate: Bool) {
        for notification in notifications {
            notification.deleteFromIOS(clearFireDate: clearFireDate)
        }
    }
    
    func createNotificationsOnIOS() {
        var candidates = [NotificationCandidate]()
        for notification in notifications {
            candidates.append(contentsOf: notification.getCandidates())
        }
        LocalNotifications.shared.create(from: candidates)
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
