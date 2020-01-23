//
//  HasRepeatMode.swift
//  MyProjects
//
//  Created by Firot on 21.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation


protocol HasRepeatMode: class {
    var repeatMode: Int { get  set }
    
    var repeatStartDate: Date?  { get  set }
    var repeatEndDate: Date?  { get  set }
    
    var nextFireDate: Date? { get set }
    
    var selectedDays: [Int]  { get  set }
    var repeatPeriod: Int  { get  set }
}

extension HasRepeatMode {
    var wrappedRepeatMode: RepeatMode {
        get {
            RepeatMode(rawValue: repeatMode) ?? RepeatMode.none
        } set {
            repeatMode = newValue.rawValue
        }
    }
    
    var calendar: Calendar {
        Calendar.current
    }
    
    var referenceDate: Date {
        nextFireDate ?? repeatStartDate ?? Date()
    }
    
    var startHour: Int {
        guard let startDate = repeatStartDate else { fatalError("start date is nil") }
        return calendar.component(.hour, from: startDate)
    }
    
    var startMinute: Int {
        guard let startDate = repeatStartDate else { fatalError("start date is nil") }
        return calendar.component(.minute, from: startDate)
    }
    
    var startWeek: Int {
        guard let startDate = repeatStartDate else { fatalError("start date is nil") }
        return calendar.component(.weekOfYear, from: startDate)
    }
    
    func setNextFireDate() {
        if isNextFireDateValid() { return }
        
        switch wrappedRepeatMode {
            case .none:
                setFireDateForNone()
            case .hour:
                setFireDateForHourly()
            case .day:
                setFireDateForDaily()
            case .week:
                setFireDateForWeeklyAndMonthly()
            case .month:
                setFireDateForWeeklyAndMonthly()
        }
        
        if let nextFireDate = self.nextFireDate, !isInRange(date: nextFireDate) {
            self.nextFireDate = nil
        }
        
        print(nextFireDate?.toRelative() ?? "no fire date")
    }
    
    private func setFireDateForNone() {
        if let notification = self as? MNotification, let date = notification.date, date > Date()  {
            nextFireDate = notification.date
        } else {
            nextFireDate = nil
        }
    }
    
    private func setFireDateForHourly() {
        guard let startDate = repeatStartDate else { fatalError("start date is nil")}
        
        let now = Date()
        var fireDate = calendar.date(bySetting: .minute, value: startMinute, of: now)!
        
        if fireDate <= now {
            fireDate.addHours(1)
            
            while(fireDate.hoursPassed(from: startDate) % repeatPeriod != 0 || fireDate < startDate ) {
                fireDate.addHours(1)
            }
        }

        nextFireDate = fireDate
    }
    
    private func setFireDateForDaily() {
        guard let startDate = repeatStartDate else { fatalError("start date is nil") }
        
        let now = Date()
        var fireDate = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now)!
        
        if fireDate <= now {
            fireDate.addDays(1)
            
            while (fireDate.daysPassed(from: startDate) % repeatPeriod != 0 || fireDate < startDate ) {
                fireDate.addDays(1)
            }
        }

        nextFireDate = fireDate
    }
    
    private func setFireDateForWeeklyAndMonthly() {
        guard let startDate = repeatStartDate else { fatalError("start date is nil") }
        
        let now = Date()
        var fireDate = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now)!
        
        func isInPeriod() -> Bool {
            if wrappedRepeatMode == .week {
                return fireDate.weekDifference(from: startDate) % repeatPeriod == 0
            } else {
                return fireDate.monthDifference(from: startDate) % repeatPeriod == 0
            }
        }
        
        func isSelectedDay() -> Bool {
            if wrappedRepeatMode == .week {
                return selectedDays.contains(calendar.component(.weekday, from: fireDate))
            } else {
                return selectedDays.contains(calendar.component(.day, from: fireDate))
            }
        }
        
        func isFireDate() -> Bool {
            if fireDate <= now || fireDate < startDate {
                return false
            } else if !isSelectedDay() {
                return false
            } else if !isInPeriod() {
                return false
            }
            return true
        }
        
        while !isFireDate() {
            fireDate.addDays(1)
        }
        
        nextFireDate = fireDate
    }
    
    private func setFireDateForMonthly() {
        
    }
    
    private func isNextFireDateValid() -> Bool {
        if let nextFireDate = self.nextFireDate, nextFireDate > Date() { return true }
        return false
    }
    
    private func isInRange(date: Date) -> Bool {
        if let repeatEndDate = self.repeatEndDate, date >= repeatEndDate { return false }
        return true
    }
}
