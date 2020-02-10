//
//  MNotification+GetActiveNotifications.swift
//  MyProjects
//
//  Created by Firot on 10.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension MNotification {
    static func getActiveNotifications(context: NSManagedObjectContext
    ) -> [MNotification] {
        var activeNotifications = [MNotification]()
        let fetchRequest: NSFetchRequest<MNotification> = MNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nextFireDate != nil")
        
        do {
            activeNotifications = try context.fetch(fetchRequest)
            return activeNotifications
        } catch {
            fatalError("Unable to fetch notifications.")
        }
        
    }
}
