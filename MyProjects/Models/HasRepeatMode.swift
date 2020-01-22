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
    
    var selectedDateIndex: [Int]  { get  set }
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
    
    func setNextFireDate() {
        if isNextFireDateValid() { return }
        
        switch wrappedRepeatMode {
            case .none:
                setFireDateForHourly()
            case .hour:
                setFireDateForHourly()
            case .day:
                setFireDateForDaily()
            case .week:
                setFireDateForWeekly()
            case .month:
                setFireDateForMonthly()
        }
        
        if let nextFireDate = self.nextFireDate, !isInRange(date: nextFireDate) {
            self.nextFireDate = nil
        }
    }
    
    private func setFireDateForNone() {
        if let notification = self as? MNotification, let date = notification.date, date > Date()  {
            nextFireDate = notification.date
        } else {
            nextFireDate = nil
        }
    }
    
    private func setFireDateForHourly() {
        guard let startDate = repeatStartDate else { return }
        
        let now = Date().withZeros()
        let startMinute = calendar.component(.minute, from: startDate)
        
        var fireDate = Calendar.current.date(bySetting: .minute, value: startMinute, of: now)!
        if fireDate < now { fireDate.addHours(1) }
        
        while(fireDate.hoursPassed(from: startDate) % repeatPeriod != 0) {
            fireDate.addHours(1)
        }
        
        nextFireDate = fireDate
    }
    
    private func setFireDateForDaily() {
        guard let startDate = repeatStartDate else { return }
        
        let now = Date().withZeros()
        let startHour = calendar.component(.hour, from: startDate)
        let startMinute = calendar.component(.minute, from: startDate)
        
        var fireDate = Calendar.current.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now)!
        
        if fireDate < now { fireDate.addDays(1) }

        while (fireDate.daysPassed(from: startDate) % repeatPeriod != 0) {
            fireDate.addDays(1)
        }
        nextFireDate = fireDate
    }
    
    private func setFireDateForWeekly() {
        
    }
    
    private func setFireDateForMonthly() {
        
    }
    
    private func isNextFireDateValid() -> Bool {
        if let nextFireDate = self.nextFireDate, nextFireDate > Date() { return true }
        return false
    }
    
    private func isInRange(date: Date) -> Bool {
        if let repeatEndDate = self.repeatEndDate, date > repeatEndDate { return false }
        return true
    }
}
