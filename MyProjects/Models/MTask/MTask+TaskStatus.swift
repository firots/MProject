//
//  MTask+TaskStatus.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

extension MTask {
    public enum TaskStatus: String {
        case active
        case completed
        case expired
        
        static let all = [active, completed, expired]
        static let colors = [Color(UIColor.systemBackground), Color.green, Color.red]
    }
}
