//
//  Date+NowWithZero.swift
//  MyProjects
//
//  Created by Firot on 23.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func withZeros() -> Date {
        let dateWithZeroSec = Calendar.current.date(bySetting: .second, value: 0, of: self)!
        let dateWithZeroNanoSec = Calendar.current.date(bySetting: .nanosecond, value: 0, of: dateWithZeroSec)!
        
        return dateWithZeroNanoSec
    }
}
