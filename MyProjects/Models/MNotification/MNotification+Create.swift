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
    static func createOrSync(from viewModel: AddNotificationViewModel?, context moc: NSManagedObjectContext) -> MNotification {
        let notification = viewModel?.mNotification ?? createBase(context: moc, model: viewModel)
        notification.nextFireDate = nil
        
        if let viewModel = viewModel {
            notification.message = viewModel.message
            notification.title = viewModel.title
            notification.repeatMode = viewModel.repeatModeConfiguration.repeatMode
            
            if viewModel.repeatModeConfiguration.repeatMode == RepeatMode.none.rawValue {
                notification.date = viewModel.date
            } else {
                viewModel.repeatModeConfiguration.bind(to: notification)
            }
            
            notification.setNextFireDate(skipNow: true)
        }
        return notification
    }
    
    
    func createOnIOSIfNear(clearFireDate: Bool) {
        //print("###CREATE ON IOS IF NEAR \(self.message)")
        guard let nextFireDate = self.nextFireDate else { return }
        if let mObject = mObject, (mObject.wrappedStatus == .done ||  mObject.wrappedStatus == .failed) { return }
        if isNextFireDateValid(for: nextFireDate) {
            LocalNotifications.shared.create(from: self.getCandidates())
        } else {
            if clearFireDate {
                self.nextFireDate = nil
            }
        }
    }
    
    func deleteFromIOS(clearFireDate: Bool) {
        LocalNotifications.shared.delete(id: wrappedID)
        if clearFireDate {
            nextFireDate = nil
        }
        for subID in subID {
            LocalNotifications.shared.delete(id: subID)
        }
        subID.removeAll()
    }
    
    func isValidForMObjectStatus(for nextFireDate: Date) -> Bool {
        if let mObject = mObject {
            if mObject.wrappedStatus == .active || mObject.wrappedStatus == .waiting {
                return true
            }
        }
        return false
    }
    
    var mObject: MObject? {
        return task ?? project
    }
    
    func isNextFireDateValid(for nextFireDate: Date) -> Bool {
        if !isValidForMObjectStatus(for: nextFireDate) { return false }
        if let deadline = mObject?.deadline, nextFireDate > deadline {
            return false
        } else if nextFireDate < Date() {
            return false
        } else if let repeatEndDate = self.repeatEndDate, nextFireDate > repeatEndDate {
            return false
        }
        return true
    }
    
    static func createBase(context moc: NSManagedObjectContext, model: AddNotificationViewModel? ) -> MNotification {
        let notification = MNotification(context: moc)
        notification.id = model?.id ?? UUID()
        return notification
    }
}
