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
        //print("@@@DELETE \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    func delete(id: String) {
        //print("@@@DELETE \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
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
                self.delete(id: request.identifier)
            }
        })
    }
    
    func create(from candidates: [NotificationCandidate]) {
        if candidates.isEmpty { return }
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.3) {
            let center = UNUserNotificationCenter.current()

            center.getPendingNotificationRequests(completionHandler: { requests in
                var activeRequests = requests.compactMap { $0.getCandidate() }
                
                for activeRequest in activeRequests {
                    if candidates.contains(activeRequest) {
                        activeRequests.removeAll(where: { $0 == activeRequest })
                    }
                }
                
                var newCandidates: [NotificationCandidate] = candidates + activeRequests
                
                newCandidates.sort {
                    $0.date < $1.date
                }
                
                newCandidates = Array(newCandidates.prefix(64))
                
                newCandidates.reverse()

                for candidate in newCandidates {
                    self.create(id: candidate.id, title: candidate.title, message: candidate.message, date: candidate.date)
                }
                
            })
            
        }
    }
    
    
    func create(id: String, title: String, message: String, date: Date) {
        print("@@@CREATE \(date.toRelative()) \(message)")
        let content = UNMutableNotificationContent()
        content.title = title
    
        content.body = message
        content.sound = UNNotificationSound.default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func createNow(id: String, title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
    
        content.body = message
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request)
    }
    
    func register() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in

        }
    }
}

extension UNNotificationRequest {
    func getCandidate() -> NotificationCandidate? {
        guard let calendarTrigger = self.trigger as? UNCalendarNotificationTrigger, let triggerDate = calendarTrigger.nextTriggerDate() else { return nil }
        
        let candidate = NotificationCandidate(id: self.identifier, title: self.content.title, message: self.content.body, date: triggerDate)
        
        return candidate
    }
}

struct NotificationCandidate: Identifiable, Equatable {
    let id: String
    let title: String
    let message: String
    let date: Date
    
    static func ==(lhs: NotificationCandidate, rhs: NotificationCandidate) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
