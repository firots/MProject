//
//  MObject+Notifications.swift
//  MyProjects
//
//  Created by Firot on 14.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation


extension MObject {
    func deleteNotificationsFromIOS() {
        for notification in notifications {
            LocalNotifications.shared.delete(id: notification.wrappedID)
        }
    }
    
    func createNotificationsOnIOS() {
        /* create ios notifications from core data */
        if wrappedStatus == .active {
            //create user defined notifications which is not expired
            createNotificationsOnIOS()
        }
        else if wrappedStatus == .waiting {
            createActivationNotificationsOnIOS()
            createDeadlineNotificationsOnIOS()
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
    
    func resetNotificationsOnIOS() {
        deleteNotificationsFromIOS()
        createNotificationsOnIOS()
    }
}
