//
//  MTask+ChangeState.swift
//  MyProjects
//
//  Created by Firot on 11.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MTask {
    public func complete() {
        self.ended = Date()
        self.status = MObjectStatus.done.rawValue
    }
    
    public func uncomplete() {
        self.ended = nil
        self.status = isExpired ? MObjectStatus.failed.rawValue : MObjectStatus.active.rawValue
    }
}
