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
            if let d = deadline, now < d {
                deadline = d /* update ui */
            } else if let s = started, now < s {
                started = s
            }
        }
        
        if let task = self as? MTask {
            task.repeatIfNeeded(force: false, context: context)
            
            if task.repeated == true {
                return //do not go futher and create fire date for notifications
            }
        }
        
        for notification in notifications {
            notification.setNextFireDate()
        }
    }
}
