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
        let notification = createBase(context: moc)
        if let viewModel = viewModel {
            notification.details = viewModel.details
            notification.title = viewModel.title
            notification.repeatMode = viewModel.repeatModeConfiguration.repeatMode
            
            if viewModel.repeatModeConfiguration.repeatMode == RepeatMode.none.rawValue {
                notification.date = viewModel.date
            } else {
                viewModel.repeatModeConfiguration.bind(to: notification)
            }
            
            notification.setNextFireDate()
        }
        return notification
    }
    
    static func createBase(context moc: NSManagedObjectContext) -> MNotification {
        let notification = MNotification(context: moc)
        notification.id = UUID()
        notification.created = Date()
        return notification
    }
}
