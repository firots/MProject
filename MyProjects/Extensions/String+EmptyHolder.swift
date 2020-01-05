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
