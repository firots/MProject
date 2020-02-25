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
    
    func setNextFireDate(skipNow: Bool) {
        if self.isNextFireDateStillInFuture() { return }
        
        let fireDate = getNextFireDate(skipNow: skipNow, after: nil)
        setNextFireDate(to: fireDate)
        
        //print("## \(self.nextFireDate?.toRelative())")
    }

    func getNextFireDate(skipNow: Bool, after: Date?) -> Date? {
        if self.isNextFireDateStillInFuture() && after == nil { return nextFireDate }
        
        var fireDate: Date?
        
        switch self.wrappedRepeatMode {
            case .none:
                fireDate = getFireDateForNone()
            case .hour:
                fireDate = getFireDateForHourly(skipNow: skipNow, after)
            case .day:
                fireDate = getFireDateForDaily(skipNow: skipNow, after)
            case .week:
                fireDate = getFireDateForWeeklyAndMonthly(skipNow: skipNow, after)
            case .month:
                fireDate = getFireDateForWeeklyAndMonthly(skipNow: skipNow, after)
        }
        
        if let fireDate = fireDate, !self.isInRange(date: fireDate) {
            return nil
        } else {
            return fireDate
        }
    }
    
    private func getFireDateForNone() -> Date? {
        if let notification = self as? MNotification, let date = notification.date, date > Date()  {
            return notification.date
        } else {
           return nil
        }
    }
    
    private func getFireDateForHourly(skipNow: Bool, _ after: Date?) -> Date? {
        guard let startDate = repeatStartDate else { return nil }
        
        let now = after ?? (self is MTask ? startDate: Date())
        var fireDate = calendar.date(bySetting: .minute, value: startMinute, of: now)!
        
        func isInPeriod() -> Bool {
            fireDate.hoursPassed(from: startDate) % repeatPeriod == 0
        }
        
        func isFireDate() -> Bool {
            if (skipNow == true && fireDate <= now)  || fireDate < startDate {
                return false
            } else if !isInPeriod() {
                return false
            }
            return true
        }
    
        while(!isFireDate()) {
            fireDate.addHours(1)
        }
        
        return fireDate
    }
    
    private func setNextFireDate(to date: Date?) {
        if nextFireDate != date {
            nextFireDate = date
        }
    }

    private func getFireDateForDaily(skipNow: Bool, _ after: Date?) -> Date? {
        guard let startDate = repeatStartDate else { return nil }
        
        let now = after ?? (self is MTask ? startDate: Date())
        var fireDate = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now)!
        
        func isInPeriod() -> Bool {
            fireDate.daysPassed(from: startDate) % repeatPeriod == 0
        }
        
        func isFireDate() -> Bool {
            if (skipNow == true && fireDate <= now) || fireDate < startDate {
                return false
            } else if !isInPeriod() {
                return false
            }
            return true
        }
            
        while (!isFireDate()) {
            fireDate.addDays(1)
        }
        
        return fireDate
    }

        
    
    
    private func getFireDateForWeeklyAndMonthly(skipNow: Bool, _ after: Date?) -> Date? {
        guard let startDate = repeatStartDate else { return nil }
        
        let now = after ?? (self is MTask ? startDate: Date())
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
            if (skipNow == true && fireDate <= now) || fireDate < startDate {
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
        
        return fireDate
    }
    
    
    private func isNextFireDateStillInFuture() -> Bool {
        if let nextFireDate = self.nextFireDate, nextFireDate > Date() { return true }
        return false
    }
    
    private func isInRange(date: Date) -> Bool {
        if let repeatEndDate = self.repeatEndDate, date >= repeatEndDate { return false }
        return true
    }
}
