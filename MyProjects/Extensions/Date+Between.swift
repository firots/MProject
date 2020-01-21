//
//  Date+Between.swift
//  MyProjects
//
//  Created by Firot on 21.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func hoursPassed() -> Int {
        getComponentsForNow(components: [.hour]).hour ?? 0
    }
    
    func daysPassed() -> Int {
        getComponentsForNow(components: [.day]).day ?? 0
    }
    
    func weeksPassed() -> Int {
        getComponentsForNow(components: [.weekOfYear]).weekOfYear ?? 0
    }
    
    func monthsPassedPassed() -> Int {
        getComponentsForNow(components: [.month]).month ?? 0
    }
    
    private func getComponentsForNow(components: Set<Calendar.Component>) -> DateComponents {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents(components, from: now, to: self)
        
        return components
    }
}
