//
//  Date+ToString.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func toRelative() -> String {
        return self.toString(isRelative: true)
    }
    
    func toString( isRelative: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = isRelative

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let date = dateFormatter.string(from: self)
        let time = timeFormatter.string(from: self)
        
        return "\(date) \(time)"
    }
    
    func toTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let time = timeFormatter.string(from: self)
        
        return time
    }
    
    func toClassic() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "d MMMM EEE"

        let date = dateFormatter.string(from: self)
        
        return date
    }
}
