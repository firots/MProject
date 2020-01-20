//
//  AddNotificationView.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddNotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: AddNotificationViewModel
    @ObservedObject private var keyboard: KeyboardResponder
    var isNew: Bool
    var addAction: (() -> Void)?
    
    init(notification: AddNotificationViewModel, keyboard: KeyboardResponder, isNew: Bool, addAction: (() -> Void)?) {
        model = notification
        self.keyboard = keyboard
        self.isNew = isNew
        self.addAction = addAction
    }
    
    var body: some View {
        VStack {
            titleBar()
            RepeatModePicker(model: $model.repeatModeConfiguration, desc: RepeatMode.descriptions[model.repeatModeConfiguration.repeatMode])
            Form {
                if model.repeatModeConfiguration.repeatMode == RepeatMode.none.rawValue {
                    oneTimeRepeat()
                } else {
                    ConfigureRepeatModeView(model: $model.repeatModeConfiguration)
                }
                
            }
            .padding(.bottom, keyboard.currentHeight)
            .background(Color(.systemGroupedBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.mNotification == nil ? "Add Notification": "Edit Notification", edit: false) {
            self.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func save() {
        if isNew {
            self.addAction?()
        }
    }
    
    func oneTimeRepeat() -> some View {
        Section {
            DateTimePicker(date: $model.date)
        }
        
    }
}

/*struct AddNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationView(notification: nil)
    }
}*/
