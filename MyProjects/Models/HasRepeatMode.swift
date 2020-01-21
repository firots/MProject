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

    var wrappedRepeatMode: RepeatMode { get set }
}

extension HasRepeatMode {
    func setNextFireDate() {
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
    }
    
    var wrappedRepeatMode: RepeatMode {
        get {
            RepeatMode(rawValue: repeatMode) ?? RepeatMode.none
        } set {
            repeatMode = newValue.rawValue
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
        if !isNextFireDateValid() { return }
        
    }
    
    private func setFireDateForDaily() {
        if !isNextFireDateValid() { return }
    }
    
    private func setFireDateForWeekly() {
        if !isNextFireDateValid() { return }
    }
    
    private func setFireDateForMonthly() {
        if !isNextFireDateValid() { return }
    }
    
    private func isNextFireDateValid() -> Bool {
        if let nextFireDate = nextFireDate, nextFireDate > Date() { return true }
        return false
    }
    

}
