//
//  NotesView.swift
//  MyProjects
//
//  Created by Firot on 9.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @Binding var notes: String
    @State var jenas = true
    @ObservedObject var keyboard: KeyboardResponder
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        return VStack {
            ModalTitle(title: "Details", edit: false) {
                self.presentationMode.wrappedValue.dismiss()
            }
            TextView(text: $notes, isEditing: $jenas)
        }
        .padding(.bottom, keyboard.currentHeight)
    }
}

