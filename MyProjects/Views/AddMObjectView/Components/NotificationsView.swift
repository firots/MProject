//
//  NotificationsView.swift
//  MyProjects
//
//  Created by Firot on 20.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var model: NotificationsViewModel
    @State var isEditing = false
    var modalAction: (() -> Void)?
    
    var body: some View {
        Group {
            addNotificationButton()
            if model.notifications.count > 0 {
                listNotifications()
            }
        }
    }
    
    func listNotifications() -> some View {
        Section {
            ForEach (0..<model.notifications.count, id: \.self) { index in
                self.notificationCell(index)
            }
        }
    }
    
    func notificationCell(_ index: Int) -> some View {
        let notification = self.model.notifications[index]
        return HStack {
            Text(notification.id.uuidString)
        }.onTapGesture {
            self.model.isNew = false
            self.model.notificationToAdd = notification
            self.modalAction?()
        }
    }
    
    func addNotificationButton() -> some View {
        Section {
            HStack {
                CellImageView(systemName: "plus.circle.fill")
                Text("Add Notification")
                .foregroundColor(Color(.systemPurple))
                Spacer()
            }
            .foregroundColor(Color(.systemPurple))
            .contentShape(Rectangle())
            .onTapGesture {
                self.model.isNew = true
                self.model.notificationToAdd = AddNotificationViewModel(from: nil)
                self.modalAction?()
            }
        }
    }
}

/*struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}*/

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AddNotificationViewModel]
    var notificationToAdd = AddNotificationViewModel(from: nil)
    var isNew = false
    
    init(notifications: [AddNotificationViewModel]) {
        self.notifications = notifications
    }
}
