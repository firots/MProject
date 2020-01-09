//
//  NotificationPeriod.swift
//  MyProjects
//
//  Created by Firot on 8.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

enum RepeatingPeriod: String {
    case none
    case daily
    case dow
    case dom
    case wdom
    
    static var all = [none, daily, dow, dom, wdom]
    
    static var descriptions = [
        "Does not repeat",
        "Repeats every day",
        "Repeats every week of day",
        "Repeats every day of month",
        "Repeats every day of week of month"
    ]
}
