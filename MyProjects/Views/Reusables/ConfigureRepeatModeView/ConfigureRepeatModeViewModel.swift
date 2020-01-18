//
//  ConfigureRepeatModeViewModel.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

struct ConfigureRepeatModeViewModel<T: HasRepeatMode> {
    var repeatMode: Int
    
    var hasStartStop: Bool
    
    var startDate: Date
    var endDate: Date
    
    var repeatMinute: Int
    var repeatHour: Int
    var repeatInterval: Int
    var repeatPeriod: Int
    

    init(from notification: T?) {
        var date: Date
        if let notification = notification as? MNotification {
            date = notification.date ?? Date()
        } else {
            date = Date()
        }
        
        repeatMode = notification?.repeatMode ?? RepeatMode.none.rawValue
        repeatMinute = notification?.repeatMinute ?? Calendar.current.component(.minute, from: date)
        repeatHour = notification?.repeatHour ?? Calendar.current.component(.hour, from: date)
        
        repeatInterval = notification?.repeatInterval ?? 1
        repeatPeriod = notification?.repeatPeriod ?? 1
        
        startDate = notification?.startDate ?? Date()
        endDate = notification?.endDate ?? Date()
        
        if notification?.startDate != nil {
            hasStartStop = true
        } else {
            hasStartStop = false
        }
    }
}

protocol HasRepeatMode {
    var repeatMode: Int { get  set }
    
    var startDate: Date?  { get  set }
    var endDate: Date?  { get  set }
    
    var repeatMinute: Int  { get  set }
    var repeatHour: Int  { get  set }
    var repeatInterval: Int  { get  set }
    var repeatPeriod: Int  { get  set }
}

public enum RepeatMode: Int {
    case none
    case hour
    case day
    case dow
    case dom
    
    static var names = ["none", "hourly", "daily", "dow", "dom"]
    
    static var all = [none, hour, day, dow, dom]
    
    static var descriptions = [
        "Does not repeat",
        "Repeats every hour",
        "Repeats every day",
        "Repeats at selected days of the week",
        "Repeats at selected days of the month",
    ]
}
