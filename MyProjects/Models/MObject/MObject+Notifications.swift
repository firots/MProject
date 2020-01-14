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
         core data and delete them from ios notifications by id*/
    }
    
    func createNotifications() {
        /* create ios notifications from core data */
    }
    
    func resetNotifications() {
        deleteNotifications()
        
        if wrappedStatus == .active {
            createNotifications()
        }
        
    }
}
