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
    
    var selectedDayOfWeekIndex = [0]
    var selectedDayOfMonthIndex = [0]
    
    var repeatHoursPeriod = 1
    var repeatDaysPeriod = 1
    var repeatWeeksPeriod = 1
    var repeatMonthsPeriod = 1

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
        
        if notification?.repeatMode == RepeatMode.month.rawValue {
            selectedDayOfMonthIndex = notification?.selectedDateIndex ?? [0]
            repeatMonthsPeriod = notification?.repeatPeriod ?? 1
        } else if notification?.repeatMode == RepeatMode.week.rawValue {
            selectedDayOfWeekIndex = notification?.selectedDateIndex ?? [0]
            repeatWeeksPeriod = notification?.repeatPeriod ?? 1
        } else if notification?.repeatMode == RepeatMode.day.rawValue {
            repeatDaysPeriod = notification?.repeatPeriod ?? 1
        }  else if notification?.repeatMode == RepeatMode.hour.rawValue {
            repeatHoursPeriod = notification?.repeatPeriod ?? 1
        }
        
        
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
    var selectedDateIndex: [Int]  { get  set }
    var repeatPeriod: Int  { get  set }
}

public enum RepeatMode: Int {
    case none
    case hour
    case day
    case week
    case month
    
    static var names = ["none", "hourly", "daily", "weekly", "monthly"]
    
    static var all = [none, hour, day, week, month]
    
    static var descriptions = [
        "Does not repeat",
        "Repeats every hour",
        "Repeats every day",
        "Repeats at selected days of the week",
        "Repeats at selected days of the month",
    ]
}
