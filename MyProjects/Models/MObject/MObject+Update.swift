//
//  MObject+Update.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MObject {
    func update() {
        let now = Date()
        
        if let d = deadline, now >= d {
            wrappedStatus = .failed
        } else if wrappedStatus == .waiting, let s = started, now >= s {
            wrappedStatus = .active
        }

        if let task = self as? MTask {
            task.repeatIfNeeded(force: false)
            
            if task.repeatTask != nil {
                return //do not go futher and create fire date for notifications
            }
        }
        
        for notification in notifications {
            notification.setNextFireDate()
        }
    }
}
