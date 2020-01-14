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
        ended = Date()
        status = MObjectStatus.done.rawValue
    }
    
    public func uncomplete() -> MObjectStatus {
        ended = nil
        status = isExpired ? MObjectStatus.failed.rawValue : MObjectStatus.active.rawValue
        if isExpired {
            return .failed
        }
        return .active
    }
}
