//
//  LocalNotifications.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

class LocalNotifications: NSObject {
    
    static let shared = LocalNotifications()
    
    override private init() {
        super.init()
    }
    
    func deleteAll() {
        //print("DELETE ALL NOTIFICATIONS ON IOS")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func delete(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    

    func clearBastards(context: NSManagedObjectContext) {
        let center = UNUserNotificationCenter.current()

        center.getPendingNotificationRequests(completionHandler: { requests in
            if requests.isEmpty { return }
            let activeNotifications = MNotification.getActiveNotifications(context: context)
            var notificationsToDelete = requests
            outerLoop: for request in requests {
                for notification in activeNotifications {
                    if notification.wrappedID.uuidString == request.identifier || notification.subID.contains(UUID(uuidString: request.identifier) ?? UUID()) {
                        notificationsToDelete.removeAll(where: {$0.identifier == request.identifier})
                        continue outerLoop
                    }
                }
            }
            for request in notificationsToDelete {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        })
    }
    
    func create(from model: MNotification) {
        guard let id = model.id else { return }
        guard let date = model.nextFireDate else { return }
        create(id: id, title: model.wrappedTitle, message: model.wrappedMessage, date: date)
        

        
        if model.wrappedRepeatMode == .hour {
            if model.subID.isEmpty {
                for _ in 1...36 {
                    model.subID.append(UUID())
                }
            }
            var nextFireDate = date
            for subID in model.subID {
                nextFireDate.addHours(model.repeatPeriod)
                if model.isNextFireDateValid(for: nextFireDate) {
                    create(id: subID, title: model.wrappedTitle, message: model.wrappedMessage, date: nextFireDate)
                }
            }
        } else {
            for subID in model.subID {
                delete(id: subID)
            }
            model.subID.removeAll()
        }
        
    }
    
    func create(id: UUID, title: String, message: String, date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
    
        content.body = message
        content.sound = UNNotificationSound.default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func register() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            /*if success {
                
            } else if let error = error {
                
            }*/
        }
    }
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
