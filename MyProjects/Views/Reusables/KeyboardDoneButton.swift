//
//  KeyboardDoneButton.swift
//  MyProjects
//
//  Created by Firot on 13.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct KeyboardDoneButton: View {
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack {
                Spacer()
                if show {
                    Button("Done") {
                        self.show = false
                    }.foregroundColor(Color(.systemPurple))
                }
                Spacer().frame(width: 20)
            }
        }
    }
}
