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
    
    var wrappedRepeatMode: RepeatMode {
        get {
            RepeatMode(rawValue: repeatMode) ?? RepeatMode.none
        } set {
            repeatMode = newValue.rawValue
        }
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
    }
    
    private func setFireDateForNone() {
        if let notification = self as? MNotification, let date = notification.date, date > Date()  {
            nextFireDate = notification.date
        } else {
            nextFireDate = nil
        }
    }
    
    private func setFireDateForHourly() {
        
    }
    
    private func setFireDateForDaily() {
        
    }
    
    private func setFireDateForWeekly() {
        
    }
    
    private func setFireDateForMonthly() {
        
    }
    
    private func isNextFireDateValid() -> Bool {
        if let nextFireDate = nextFireDate, nextFireDate > Date() { return true }
        return false
    }
}
