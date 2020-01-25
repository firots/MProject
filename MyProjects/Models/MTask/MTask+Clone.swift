//
//  MTask+Clone.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MTask {
    public func timeToRepeat() -> Bool {
        if wrappedRepeatMode == .none { return false }
        setNextFireDate()
        
        guard let nextFireDate = self.nextFireDate else { return false }
        
        let now = Date()
        
        if now >= nextFireDate {
            wrappedStatus = .failed
            
            /* repeat code */
        }
        
        return false
        
    }
    
}
