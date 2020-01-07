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
        return self.toString(format: "h:mm a", isRelative: true)
    }
    
    func toString(format: String, isRelative: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = isRelative

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = format
        
        let date = dateFormatter.string(from: self)
        let time = timeFormatter.string(from: self)
        
        return "\(date) \(time)"
    }
    
    func toClassic() -> String {
        return self.toString(format: "EEEE", isRelative: false)
    }
}
