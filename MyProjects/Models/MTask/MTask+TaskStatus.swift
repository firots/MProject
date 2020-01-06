//
//  MTask+TaskStatus.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MTask {
    public enum TaskStatus: String {
        case active
        case completed
        case expired
        
        static let all = [active, completed, expired]
    }
}
