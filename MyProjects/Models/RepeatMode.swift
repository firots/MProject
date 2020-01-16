//
//  NotificationPeriod.swift
//  MyProjects
//
//  Created by Firot on 8.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

public enum RepeatMode: Int {
    case none
    case hour
    case day
    case dow
    case dom
    case wdom
    
    static var names = ["none", "hourly", "daily", "dow", "dom", "wdom"]
    
    static var all = [none, hour, day, dow, dom, wdom]
    
    static var descriptions = [
        "Does not repeat",
        "Repeats every hour",
        "Repeats every day",
        "Repeats every week of day",
        "Repeats every day of month",
        "Repeats every day of week of month"
    ]
}

class AddNotificationViewModel {
    /* uuid will be transferred to notification center */
    var id: UUID
    var title: String
    var details: String
    
    /* can belong to project or task*/
    var project: MProject?
    var task: MTask?
    
    /* callback date date for non repeating notifications */
    var date: Date
    
    /* repeat section */
    var repeatMode: RepeatMode
    
    var startDate: Date?
    var endDate: Date?
    
    var repeatMinute: Int
    var repeatHour: Int
    var repeatInterval: Int
    var repeatPeriod: Int
    
    init() {
        id = UUID()
        date = Date()
        
        title = ""
        details = ""
        
        repeatMode = .none
        repeatMinute = Calendar.current.component(.minute, from: date)
        repeatHour = Calendar.current.component(.hour, from: date)
        
        repeatInterval = 1
        repeatPeriod = 1
        
    }
    
    init(from mNot: MNotification) {
        id = mNot.wrappedID
        date = mNot.date ?? Date()
        
        title = mNot.title ?? ""
        details = mNot.details ?? ""
        
        repeatMode = RepeatMode(rawValue: mNot.repeatMode) ?? RepeatMode.none
        repeatMinute = mNot.repeatMinute
        repeatHour = mNot.repeatHour
        
        repeatInterval = mNot.repeatInterval
        repeatPeriod = mNot.repeatPeriod
    }
    
    func refresh() {
        //delete from core data
        
        //recreate on core data
    }
}
