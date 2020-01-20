//
//  MNotification+Create.swift
//  MyProjects
//
//  Created by Firot on 16.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MNotification {
    static func create(from viewModel: AddNotificationViewModel?, context moc: NSManagedObjectContext) -> MNotification {
        return createBase(context: moc)
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MNotification {
        let notification = MNotification(context: moc)
        notification.id = UUID()
        notification.created = Date()
        return notification
    }
}
