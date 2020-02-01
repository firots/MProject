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
    @Environment(\.editMode) var editMode
    
    
    init(title: String, edit: Bool, action: (() -> Void)?) {
        self.title = title
        self.editable = edit
        self.action = action
    }
    
    var body: some View {
        titleBar()
    }
    
    func titleBar() -> some View {
        return VStack {
            Spacer().frame(height: 20)
            ZStack {
                HStack {
                    Spacer().frame(width: 20)
                    
                    saveButton()
                    
                    Spacer()
                    
                    if editable && editMode?.wrappedValue == .active {
                        self.editButton()
                        Spacer().frame(width: 20)
                    } else  {
                        #if targetEnvironment(macCatalyst)
                        self.closeButton()
                        Spacer().frame(width: 20)
                        #endif
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
    
    func editButton() -> some View {
        Button("Done") {
            withAnimation {
                self.editMode?.wrappedValue = .inactive
            }
        }
        .foregroundColor(Color(.systemPurple))
    }
    
    func saveButton() -> some View {
        Button("Save") {
            self.action?()
        }
        .foregroundColor(Color(.systemPurple))
    }
    
    func closeButton() -> some View {
        Button("Close") {
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
