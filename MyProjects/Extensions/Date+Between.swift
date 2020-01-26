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
    
    func monthsPassed(from date: Date?) -> Int {
        getComponents(for: date, components: [.month]).month ?? 0
    }
    
    private func getComponents(for date: Date?, components: Set<Calendar.Component>) -> DateComponents {
        let calendar = Calendar.current
        let firstDate = date ?? Date()
        
        let components = calendar.dateComponents(components, from: firstDate, to: self)
        
        return components
    }

    func weekDifference(from date: Date) -> Int {
        let startWeek = date
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withSunday() // geçmiş pazara gidemiyo o yüzden saçmalıyor sanki ya da pazarı sonra görüyor
        
        let currentWeek = self
            .withZeroHourAndMinutes()
            .withZeroSeconds()
            .withSunday()
        
        return currentWeek.weeksPassed(from: startWeek)
    }
    
    private func withStartOfMonth() -> Date {
        var components = DateComponents(year: Calendar.current.dateComponents([.year], from: self).year!, month: Calendar.current.dateComponents([.month], from: self).month!, day: 1, hour: 0, minute: 0, second: 0)
        components.nanosecond = 0

        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    
    func monthDifference(from date: Date) -> Int {
        let startMonth = date.withStartOfMonth()
        let currentMonth = self.withStartOfMonth()
        
        return currentMonth.monthsPassed(from: startMonth)
    }
    


}
