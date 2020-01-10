//
//  String+NoNewline.swift
//  MyProjects
//
//  Created by Firot on 11.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension String {
    func noNewline() -> String {
        self.replacingOccurrences(of: "\n", with: " ")
    }
}
