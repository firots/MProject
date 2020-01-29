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
            ForEach (model.notifications) { notification in
                self.notificationCell(notification)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        model.notifications.remove(atOffsets: offsets)
    }
    
    func notificationCell(_ notification: AddNotificationViewModel) -> some View {
        HStack {
            CellImageView(systemName: "bell.circle.fill")
            Text(notification.repeatModeConfiguration.wrappedRepeatMode != .none ? notification.repeatModeConfiguration.repeatText :
                notification.date.toRelative())
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


