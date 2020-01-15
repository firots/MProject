//
//  MObject+Notifications.swift
//  MyProjects
//
//  Created by Firot on 14.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation


extension MObject {
    func deleteNotifications() {
        /* get notifications from
         core data and delete them from ios notifications by id
        */
    }
    
    func createNotifications() {
        /* create ios notifications from core data */
        if wrappedStatus == .active {
            //create user defined notifications which is not expired
            //create deadline notifications
        }
        else if wrappedStatus == .waiting {
            if let started = self.started {
                if started > Date() {
                    //create auto start notifications
                }
            }
            //create deadline notifications
        }
    }
    
    func resetNotifications() {
        deleteNotifications()
        createNotifications()
    }
}
