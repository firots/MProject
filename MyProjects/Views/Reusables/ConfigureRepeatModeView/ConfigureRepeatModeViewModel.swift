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
    
    var actString: String {
        type == .task ? "Repeats" : "Reminds"
    }
    
    var repeatText: String {
        switch wrappedRepeatMode {
        case .none:
            return ""
        case .hour:
            let periodString = repeatHoursPeriod > 1 ? "\(repeatHoursPeriod) hours" : "hour"
            return "\(actString) every \(periodString) after \(repeatStartDate.toTime())"
        case .day:
            let periodString = repeatDaysPeriod > 1 ? "\(repeatHoursPeriod) days" : "day"
            return "\(actString) every \(periodString) at \(repeatStartDate.toTime())"
        case.week:
            let periodString = repeatWeeksPeriod > 1 ? "\(repeatWeeksPeriod) weeks" : "week"
            let daysArr = selectedDayOfWeekIndex.map { Calendar.current.weekdaySymbols[$0] }
            let repeatDaysString = daysArr.joined(separator: ", ")
            return "\(actString) every \(periodString) at \(repeatStartDate.toTime()) on days: \(repeatDaysString)"
        case.month:
            let periodString = repeatMonthsPeriod > 1 ? "\(repeatMonthsPeriod) months" : "month"
            let daysArr = selectedDayOfMonthIndex.map { String($0 + 1) }
            let repeatDaysString = daysArr.joined(separator: ", ")
            return "\(actString) every \(periodString) at \(repeatStartDate.toTime()) on days: \(repeatDaysString)"
        }
    }

    init(from notification: T?, type: RepeatModeObjectType) {
        self.type = type
        
        repeatMode = notification?.repeatMode ?? RepeatMode.none.rawValue

        if notification?.repeatMode == RepeatMode.month.rawValue {
            selectedDayOfMonthIndex = notification?.selectedDays.map( {$0 - 1 }) ?? [0]
            repeatMonthsPeriod = notification?.repeatPeriod ?? 1
        } else if notification?.repeatMode == RepeatMode.week.rawValue {
            selectedDayOfWeekIndex = notification?.selectedDays.map( {$0 - 1 }) ?? [0]
            repeatWeeksPeriod = notification?.repeatPeriod ?? 1
        } else if notification?.repeatMode == RepeatMode.day.rawValue {
            repeatDaysPeriod = notification?.repeatPeriod ?? 1
        }  else if notification?.repeatMode == RepeatMode.hour.rawValue {
            repeatHoursPeriod = notification?.repeatPeriod ?? 1
        }
        
        let now = Date()
        
        if let startDate = notification?.repeatStartDate, notification?.repeatMode != RepeatMode.none.rawValue {
            repeatStartDate = startDate
        } else {
            var startDate = now.withZeroSeconds()
            startDate.addMinutes(-1)
            repeatStartDate = startDate
        }
        repeatEndDate = notification?.repeatEndDate ?? now.withZeroSeconds()
        
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
                repeatingObject.selectedDays = selectedDayOfWeekIndex.map( {$0 + 1 }).sorted()
            } else if wrappedRepeatMode == .month {
                repeatingObject.repeatPeriod = repeatMonthsPeriod
                repeatingObject.selectedDays = selectedDayOfMonthIndex.map( {$0 + 1 }).sorted()
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
        "Repeats every x hours",
        "Repeats every x days",
        "Repeats every x weeks on selected week days",
        "Repeats every x months on selected month days",
    ]
}
