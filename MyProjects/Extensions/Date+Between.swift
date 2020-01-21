//
//  Date+Between.swift
//  MyProjects
//
//  Created by Firot on 21.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func hoursPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.hour]).hour ?? 0
    }
    
    func daysPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.day]).day ?? 0
    }
    
    func weeksPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.weekOfYear]).weekOfYear ?? 0
    }
    
    func monthsPassedPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.month]).month ?? 0
    }
    
    private func getComponents(for date: Date?, components: Set<Calendar.Component>) -> DateComponents {
        let calendar = Calendar.current
        let firstDate = date ?? Date()
        
        let components = calendar.dateComponents(components, from: firstDate, to: self)
        
        return components
    }
}
