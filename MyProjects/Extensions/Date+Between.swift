//
//  Date+Between.swift
//  MyProjects
//
//  Created by Firot on 21.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension Date {
    func minutesPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.minute]).minute ?? 0
    }
    
    func hoursPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.hour]).hour ?? 0
    }
    
    func daysPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.day]).day ?? 0
    }
    
    func weeksPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.weekOfYear]).weekOfYear ?? 0
    }
    
    func weekDifference(from date: Date) -> Int {
        let startWeek = date
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withSunday()

        
        let currentWeek = self
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withSunday()
        
        return currentWeek.weeksPassed(from: startWeek)
    }
    
    func monthDifference(from date: Date) -> Int {
        let startMonth = date
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withFirstDayOfMonth()
        
        let currentMonth = date
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withFirstDayOfMonth()
        
        return currentMonth.monthsPassed(from: startMonth)
    }
    
    func monthsPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.month]).month ?? 0
    }
    
    private func getComponents(for date: Date?, components: Set<Calendar.Component>) -> DateComponents {
        let calendar = Calendar.current
        let firstDate = date ?? Date()
        
        let components = calendar.dateComponents(components, from: firstDate, to: self)
        
        return components
    }
}
