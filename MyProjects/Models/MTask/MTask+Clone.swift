//
//  MTask+Clone.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MTask {
    public func repeatIfNeeded() {
        if wrappedRepeatMode == .none { return } //not repeating type
        
        if repeatTask != nil { return } //already has repeated task
        
        setNextFireDate() //set the nextfiredate
        
        guard let nextFireDate = self.nextFireDate else { return } //be sure next fire date is valid
        
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
         
 
        */
    }
    
}
