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
    @Published var hasAutoStart = false
    @Published var modalType = ModalType.notes
    @Published var showExpiredWarning = false

    private var cancellableSet: Set<AnyCancellable> = []
    
    var notificationsModel: NotificationsViewModel
    
    var status: MObjectStatus {
        return MObjectStatus.all[statusIndex]
    }
    
    private var hasDeadlinePublisher: AnyPublisher<Bool, Never> {
        $hasDeadline
            .map { hasDeadline in
                hasDeadline
            }
            .eraseToAnyPublisher()
    }
    
    private var deadlineExpiredPublisher: AnyPublisher<Bool, Never> {
        $deadline
            .map { deadline in
                Date() > deadline
            }
            .eraseToAnyPublisher()
    }
    
    private var statusPublisher: AnyPublisher<MObjectStatus, Never> {
        $statusIndex
            .map { statusIndex in
                MObjectStatus.all[statusIndex]
            }
            .eraseToAnyPublisher()
    }
    
    private var showExpiredWarningPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(hasDeadlinePublisher, deadlineExpiredPublisher, statusPublisher)
            .map { deadline, expired, status in
                deadline && expired && (status == .active || status == .waiting)
        }
        .eraseToAnyPublisher()
    }
    
    init(mObject: MObject?) {
        self.statusIndex = MObjectStatus.all.firstIndex(of: MObjectStatus(rawValue: mObject?.status ?? MObjectStatus.active.rawValue) ?? MObjectStatus.active) ?? 1
        
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
                hasAutoStart = true
                autoStart = started
            }
            
        }
        
        let notifications = mObject?.notifications.map( { AddNotificationViewModel(from: $0) }) ?? [AddNotificationViewModel]()
        
        notificationsModel = NotificationsViewModel(notifications: notifications)
        
        showExpiredWarningPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.showExpiredWarning, on: self)
            .store(in: &cancellableSet)
    }
    
    enum ModalType {
        case notes
        case addNotification
        case addStep
    }
}
