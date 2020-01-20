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
    
    var repeatStartDate: Date
    var repeatEndDate: Date
    
    var timeDate: Date
    
    var repeatMinute: Int

    var selectedDayOfWeekIndex = [0]
    var selectedDayOfMonthIndex = [0]
    
    var repeatHoursPeriod = 1
    var repeatDaysPeriod = 1
    var repeatWeeksPeriod = 1
    var repeatMonthsPeriod = 1
    
    var type: RepeatModeObjectType
    
    var wrappedRepeatMode: RepeatMode {
        return RepeatMode(rawValue: repeatMode) ?? .none
    }

    init(from notification: T?, type: RepeatModeObjectType) {
        self.type = type
        
        var date: Date
        if let notification = notification as? MNotification {
            date = notification.date ?? Date()
        } else {
            date = Date()
        }
        
        repeatMode = notification?.repeatMode ?? RepeatMode.none.rawValue
        repeatMinute = notification?.repeatMinute ?? Calendar.current.component(.minute, from: date)
        
        timeDate = Calendar.current.date(bySettingHour: notification?.repeatHour ?? 0, minute: notification?.repeatMinute ?? 0, second: 0, of: Date()) ?? Date()

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
        
        
        repeatStartDate = notification?.repeatStartDate ?? Date()
        repeatEndDate = notification?.repeatEndDate ?? Date()
        
        if notification?.repeatStartDate != nil {
            hasStartStop = true
        } else {
            hasStartStop = false
        }
    }
    
    func bind(to repeatingObject: T) {
        if wrappedRepeatMode == .hour {
            repeatingObject.repeatPeriod = repeatHoursPeriod
            repeatingObject.repeatMinute = repeatMinute
        } else {
            if wrappedRepeatMode == .day {
                repeatingObject.repeatPeriod = repeatDaysPeriod
            } else if wrappedRepeatMode == .week {
                repeatingObject.repeatPeriod = repeatWeeksPeriod
                repeatingObject.selectedDateIndex = selectedDayOfWeekIndex
            } else if wrappedRepeatMode == .month {
                repeatingObject.repeatPeriod = repeatMonthsPeriod
                repeatingObject.selectedDateIndex = selectedDayOfMonthIndex
            }
            repeatingObject.repeatMinute = Calendar.current.component(.minute, from: timeDate)
            repeatingObject.repeatHour = Calendar.current.component(.hour, from: timeDate)
        }

        if hasStartStop {
            repeatingObject.repeatStartDate = repeatStartDate
            repeatingObject.repeatEndDate = repeatEndDate
        } else {
            repeatingObject.repeatStartDate = nil
            repeatingObject.repeatEndDate = nil
        }
        
    }
    
    
}

protocol HasRepeatMode: class {
    var repeatMode: Int { get  set }
    
    var repeatStartDate: Date?  { get  set }
    var repeatEndDate: Date?  { get  set }
    
    var repeatMinute: Int  { get  set }
    var repeatHour: Int  { get  set }
    var selectedDateIndex: [Int]  { get  set }
    var repeatPeriod: Int  { get  set }
}

public enum RepeatModeObjectType {
    case notification
    case task
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
        "Repeats at every x hour",
        "Repeats at every x day",
        "Repeats at selected days of the week",
        "Repeats at selected days of the month",
    ]
}
