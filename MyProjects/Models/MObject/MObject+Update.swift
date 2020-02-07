//
//  MObject+Update.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MObject {
    func update(_ context: NSManagedObjectContext) {
        let now = Date()
        
        if let d = deadline, now >= d {
            setStatus(to: .failed, context: context)
        } else if wrappedStatus == .waiting, let s = started, now >= s {
            setStatus(to: .active, context: context)
        } else {
            if let d = deadline, now < d { /* update ui */
                objectWillChange.send()
            } else if let s = started, now < s {
                objectWillChange.send()
            }
        }
        
        if let task = self as? MTask {
            if task.wrappedRepeatMode != .none {
                task.repeatIfNeeded(force: false, context: context)
                
                if task.wrappedRepeatMode == .none {
                    return //do not go futher and create fire date for notifications of repeated task
                }
            }

        }
        
        for notification in notifications {
            notification.setNextFireDate()
        }
    }
}
