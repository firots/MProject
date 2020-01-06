//
//  ModalTitle.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ModalTitle: View {
    let title: String
    var action: (() -> Void)?
    
    init(title: String, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        titleBar()
    }
    
    func titleBar() -> some View {
        ZStack {
            HStack {
                Spacer()
                saveButton()
                Spacer().frame(width: 20)
            }
            
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                Spacer()
            }
        }
    }
    
    func saveButton() -> some View {
        Button("Save") {
            self.action?()
        }
        .foregroundColor(Color.purple)
    }
}

struct ModalTitle_Previews: PreviewProvider {
    static var previews: some View {
        ModalTitle(title: "Title") {
            
        }
    }
}
