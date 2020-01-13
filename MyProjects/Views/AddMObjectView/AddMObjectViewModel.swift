//
//  AddMObjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AddMObjectViewModel: ObservableObject {
    @Published var name = ""
    @Published var details = ""
    @Published var deadline = Date()
    @Published var hasDeadline = false
    @Published var statusIndex: Int
    @Published var showModal = false
    @Published var autoStart = Date()
    @Published var ended: Date?
    @Published var started: Date?
    @Published var showAutoStart = false
    @Published var modalType = ModalType.notes
    
    var status: MObjectStatus {
        return MObjectStatus.all[statusIndex]
    }
    
    init(mObject: MObject?) {
        self.statusIndex = MObjectStatus.all.firstIndex(of: MObjectStatus(rawValue: mObject?.status ?? MObjectStatus.active.rawValue) ?? MObjectStatus.active) ?? 0
        
        if let o = mObject {
            name = o.name ?? ""
            details = o.details ?? ""
            started = o.started
            ended = o.ended
            if let deadline = o.deadline {
                hasDeadline = true
                self.deadline = deadline
            }
            if let started = o.started, started > Date() {
                showAutoStart = true
                autoStart = started
            }
        }
    }
    
    enum ModalType {
        case notes
        case addNotification
        case addStep
    }
}
