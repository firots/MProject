//
//  MStep+Status.swift
//  MyProjects
//
//  Created by Firot on 13.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

public enum MStepStatus: Int {
    case active
    case done
    
    static let names = ["active", "done"]
    static let all = [active, done]
    static let colors = [Color(UIColor.systemBackground), Color(.systemGreen)]
    
}

