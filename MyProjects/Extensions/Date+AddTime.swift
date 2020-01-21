//
//  Date+AddTime.swift
//  MyProjects
//
//  Created by Firot on 22.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
     mutating func addHours(_ hours: Int) {
        let hourComponents = DateComponents(hour: hours)
        self = Calendar.current.date(byAdding: hourComponents, to: self)!
    }
    
     mutating func addMinutes(_ minutes: Int) {
        let minuteComponents = DateComponents(minute: minutes)
        self = Calendar.current.date(byAdding: minuteComponents, to: self)!
    }
    
     mutating func addDays(_ days: Int) {
        let dayComponents = DateComponents(day: days)
        self = Calendar.current.date(byAdding: dayComponents, to: self)!
    }
}
