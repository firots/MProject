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
        let notification = createBase(context: moc, model: viewModel)
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
    
    func createOnIOSIfNear() {
        print("CREATE ON IOS IF NEAR")
        guard let nextFireDate = self.nextFireDate else { return }
        if isNextFireDateValid() {
            let now = Date()
            if nextFireDate.hoursPassed(from: now) <= 4 {
                LocalNotifications.shared.create(from: self)
            }
        } else {
            self.nextFireDate = nil
        }
    }
    
    func isValidForMObjectStatus(for nextFireDate: Date) -> Bool {
        if let mObject = mObject {
            if mObject.wrappedStatus == .active {
                return true
            } else if mObject.wrappedStatus == .waiting {
                if let startDate = mObject.started {
                    if nextFireDate >= startDate {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    var mObject: MObject? {
        return task ?? project
    }
    
    func isNextFireDateValid() -> Bool {
        guard let nextFireDate = self.nextFireDate else { return false }
        if !isValidForMObjectStatus(for: nextFireDate) { return false }
        if let deadline = mObject?.deadline, nextFireDate > deadline {
            return false
        } else if nextFireDate <= Date() {
            return false
        }
        return true
    }
    
    static func createBase(context moc: NSManagedObjectContext, model: AddNotificationViewModel? ) -> MNotification {
        let notification = MNotification(context: moc)
        notification.id = model?.id ?? UUID()
        notification.created = Date()
        return notification
    }
}
