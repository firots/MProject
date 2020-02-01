//
//  LocalNotifications.swift
//  MyProjects
//
//  Created by Firot on 25.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotifications {
    
    static let shared = LocalNotifications()
    
    private init() {
        
    }
    
    func deleteAll() {
        //print("DELETE ALL NOTIFICATIONS ON IOS")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func delete(id: UUID) {
        //print("DELETE FROM IOS")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    func create(from model: MNotification) {
        //print("CREATE ON IOS FROM MODEL")
        guard let id = model.id else { return }
        guard let date = model.nextFireDate else { return }
        create(id: id, title: model.wrappedTitle, message: model.wrappedMessage, date: date)
    
        model.subID.removeAll()
        
        if model.wrappedRepeatMode == .hour {
            var nextFireDate = date
            for _ in 1...36 {
                nextFireDate.addHours(model.repeatPeriod)
                if model.isNextFireDateValid(for: nextFireDate) {
                    let subID = UUID()
                    create(id: subID, title: model.wrappedTitle, message: model.wrappedMessage, date: nextFireDate)
                    model.subID.append(subID)
                }
            }
        }
    }
    
    func create(id: UUID, title: String, message: String, date: Date) {
        //print("CREATED ON IOS \(date.toRelative())")
        
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
