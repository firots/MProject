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
    let editable: Bool
    @Environment(\.presentationMode) var presentationMode
    
    init(title: String, edit: Bool, action: (() -> Void)?) {
        self.title = title
        self.editable = edit
        self.action = action
    }
    
    var body: some View {
        titleBar()
    }
    
    func titleBar() -> some View {
        VStack {
            Spacer().frame(height: 20)
            ZStack {
                HStack {
                    Spacer().frame(width: 20)
                    saveButton()
                    Spacer()
                    if editable {
                        EditButton()
                        .foregroundColor(Color(.systemPurple))
                        Spacer().frame(width: 20)
                    }
                }
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
    
    func saveButton() -> some View {
        Button("Save") {
            self.action?()
        }
        .foregroundColor(Color(.systemPurple))
    }
    
    func closeButton() -> some View {
        Button("Cancel") {
            self.presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(Color(.systemPurple))
    }
}

struct ModalTitle_Previews: PreviewProvider {
    static var previews: some View {
        ModalTitle(title: "Title", edit: true) {
            
        }
    }
}
