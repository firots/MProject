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
    
    var repeatMinute: Int  { get  set }
    var repeatHour: Int  { get  set }
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
        let now = Date()
        let hour = calendar.component(.hour, from: referenceDate)
        var fireDate = Calendar.current.date(bySettingHour: hour, minute: repeatMinute, second: 0, of: Date.yesterday())!
        
        while(fireDate < now) {
            fireDate.addHours(repeatPeriod)
        }
        nextFireDate = fireDate
    }
    
    private func setFireDateForDaily() {
        let now = Date()
        var fireDate = Calendar.current.date(bySettingHour: repeatHour, minute: repeatMinute, second: 0, of: referenceDate)!
        
        while fireDate < now {
            fireDate.addDays(repeatPeriod)
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
