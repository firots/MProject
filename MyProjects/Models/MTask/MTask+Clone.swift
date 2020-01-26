//
//  MTask+Clone.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MTask {
    public func repeatIfNeeded(force: Bool) {
        print("REPEAT IF NEEDED")
        if wrappedRepeatMode == .none { return } //not repeating type
        
        if repeatTask != nil { return } //already has repeated task
        
        guard let nextFireDate = self.nextFireDate else { return } //be sure next fire date is valid
        
        if force == false && nextFireDate > Date() { return } //its not time yet
        
        setNextFireDate() //set the nextfiredate
        
        
        
        print("OH I WILL REPEAT NOW")
        
        /*let newTask = self.clone()
         clone will have nextfiredate as its repeatstartdate
         startdate as current date
         repeatTask = clone
         clone.repeatedfrom = self
         
         will copy steps to itself in active state
         
         will copy all notifications by:
            get time diff between current repeatstartdate and nextfiredate
            add diff to notificaon date if notif state is none
            else if notifstate is repeating add it to notifrepeatstartdate
         
         create nextfiredate for all notifications
         
         call repeatifneeded on new task in case missed some repeats
        */
        
        for notification in notifications {
            notification.deleteFromIOS()
        }
    }
    
}
