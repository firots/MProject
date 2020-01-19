//
//  Date+Remeans.swift
//  MyProjects
//
//  Created by Firot on 19.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func remeans() -> String {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let remeaningCalendar = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: self)
        if let days = remeaningCalendar.day, days > 0 {
            return "\(String(days)) d"
        } else if let hours = remeaningCalendar.hour, hours > 0 {
            return "\(String(hours)) h"
        } else if let minutes = remeaningCalendar.minute, minutes > 0 {
            return "\(String(minutes)) m"
        } else if let seconds = remeaningCalendar.second, seconds > 0 {
            return "\(String(seconds)) s"
        }
        return ""
    }
    
}
