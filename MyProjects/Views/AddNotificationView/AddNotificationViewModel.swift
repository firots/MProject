//
//  AddNotificationViewModel.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddNotificationViewModel: ObservableObject, Identifiable {
    /* uuid will be transferred to notification center */
    var id: UUID
    @Published var title: String
    @Published var message: String
    @Published var date: Date
    @Published var showModal = false
    
    /* can belong to project or task*/
    var mObject: MObject?
    
    var mNotification: MNotification?

    /* callback date date for non repeating notifications */
    //@Published var date: Date
    
    /* repeat section */
    @Published var repeatModeConfiguration: ConfigureRepeatModeViewModel<MNotification>
    
    init(from mNot: MNotification?) {
        id = mNot?.wrappedID ?? UUID()
        date = mNot?.date ?? Date()
        
        title = mNot?.title ?? ""
        message = mNot?.message ?? ""
        
        mNotification = mNot
        repeatModeConfiguration = ConfigureRepeatModeViewModel(from: mNot, type: .notification)
        
        mObject = mNot?.task != nil ? mNot?.task : mNot?.project
    }
}
