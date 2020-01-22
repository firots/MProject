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
        
        repeatMode = notification?.repeatMode ?? RepeatMode.none.rawValue

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
        
        let now = Date()
        
        if let startDate = notification?.repeatStartDate {
            repeatStartDate = startDate
        } else {
            var startDate = now.withZeros()
            startDate.addMinutes(-1)
            repeatStartDate = startDate
        }
        repeatEndDate = notification?.repeatEndDate ?? now.withZeros()
        
        if notification?.repeatEndDate != nil {
            hasStartStop = true
        } else {
            hasStartStop = false
        }
    }
    
    func bind(to repeatingObject: T) {
        if wrappedRepeatMode == .hour {
            repeatingObject.repeatPeriod = repeatHoursPeriod
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
        }
        
        repeatingObject.repeatStartDate = repeatStartDate

        if hasStartStop {
            repeatingObject.repeatEndDate = repeatEndDate
        } else {
            repeatingObject.repeatEndDate = nil
        }
    }
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
