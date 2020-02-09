//
//  MNotification+SyncAll.swift
//  MyProjects
//
//  Created by Firot on 9.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MNotification {
    static func syncAll(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<MNotification> = MNotification.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(MNotification.nextFireDate), ascending: true)
        
        fetchRequest.predicate = NSPredicate(format: "nextFireDate != nil")
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let notifications = try context.fetch(fetchRequest)
            for notification in notifications {
                notification.createOnIOSIfNear(clearFireDate: true)
            }

        } catch {
            fatalError("Unable to fetch notifications.")
        }
    }
}
