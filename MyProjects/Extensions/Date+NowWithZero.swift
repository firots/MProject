//
//  Date+NowWithZero.swift
//  MyProjects
//
//  Created by Firot on 23.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func withZeroSeconds() -> Date {
        let dateWithZeroSec = Calendar.current.date(bySetting: .second, value: 0, of: self)!
        let dateWithZeroNanoSec = Calendar.current.date(bySetting: .nanosecond, value: 0, of: dateWithZeroSec)!
        
        return dateWithZeroNanoSec
    }
    
    func withZeroHourAndMinutes() -> Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func withSunday() -> Date {
        Calendar.current.date(bySetting: .weekday, value: 1, of: self)!
    }
    
    func withFirstDayOfMonth() -> Date {
        Calendar.current.date(bySetting: .day, value: 1, of: self)!
    }
    
    func withFirstDayOfWeek() -> Date {
        Calendar.current.date(bySetting: .weekday, value: 1, of: self)!
    }
}
