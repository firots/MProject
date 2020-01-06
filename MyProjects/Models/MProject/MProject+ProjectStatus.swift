//
//  MProject+Status.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MProject {
    public enum ProjectStatus: String {
        case active
        case completed
        case expired
        
        static let all = [active, completed, expired]
    }
}
