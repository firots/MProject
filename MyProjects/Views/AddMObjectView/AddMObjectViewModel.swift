//
//  AddMObjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import Combine

class AddMObjectViewModel<T>: ObservableObject where T:MObject {
    @Published var name = ""
    @Published var details = ""
    @Published var deadline = Date()
    @Published var hasDeadline = false
    @Published var statusIndex: Int
    
    var mObject: T?
    
    init(mObject: T?) {
        self.mObject = mObject
        self.statusIndex = MObjectStatus.all.firstIndex(of: MObjectStatus(rawValue: mObject?.status ?? MObjectStatus.active.rawValue) ?? MObjectStatus.active) ?? 0
        
        if let o = mObject {
            name = o.name ?? ""
            details = o.details ?? ""
            if let deadline = o.deadline {
                hasDeadline = true
                self.deadline = deadline
            }
        }
    }
}
