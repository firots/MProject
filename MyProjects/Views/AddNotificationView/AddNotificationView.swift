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
                messageButton()
                
                if model.repeatModeConfiguration.repeatMode == RepeatMode.none.rawValue {
                    oneTimeRepeat()
                } else {
                    ConfigureRepeatModeView(model: $model.repeatModeConfiguration)
                }
                
            }
            .padding(.bottom, keyboard.currentHeight)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $model.showModal) {
            NotesView(notes: self.$model.message, title: "Message", keyboard: self.keyboard)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func messageButton() -> some View {
        HStack {
            CellImageView(systemName: "pencil.circle.fill")
            Text(self.model.message.emptyHolder("Message"))
                .foregroundColor(Color(.placeholderText))
                .lineLimit(3)
            Spacer()
        }.accentColor(Color(.systemPurple))
        .contentShape(Rectangle())
        .onTapGesture {
            self.model.showModal = true
        }
    }
    
    func titleBar() -> some View {
        ModalTitle(title: model.mNotification == nil ? "Add Reminder": "Edit Reminder", edit: false) {
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
            DateTimePicker(date: $model.date, text: "Send Date")
        }
        
    }
}

/*struct AddNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationView(notification: nil)
    }
}*/
