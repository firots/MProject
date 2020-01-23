//
//  NotificationsViewModel.swift
//  MyProjects
//
//  Created by Firot on 20.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AddNotificationViewModel] 
    var notificationToAdd = AddNotificationViewModel(from: nil)
    var isNew = false
    
    init(notifications: [AddNotificationViewModel]) {
        self.notifications = notifications
    }
}
