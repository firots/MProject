//
//  String+EmptyHolder.swift
//  MyProjects
//
//  Created by Firot on 5.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension String {
    func emptyHolder(_ holder: String) -> String {
        self == "" ? holder : self
    }
    
    func emptyIsNil() -> String? {
        self == "" ? nil : self
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(localized key: String, _ args: CVarArg...) {
        let localized = String(format: NSLocalizedString(key, comment: ""), arguments: args)
        appendLiteral(localized)
    }
}
