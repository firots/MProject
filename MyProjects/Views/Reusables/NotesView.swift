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
    var title: String
    @State var jenas = true
    @ObservedObject var keyboard: KeyboardResponder
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        return VStack {
            ZStack {
                ModalTitle(title: title, edit: false) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                #if !targetEnvironment(macCatalyst)
                KeyboardDoneButton(show: $jenas)
                #endif
            }
            TextView(text: $notes, isEditing: $jenas)
            .padding(.bottom, keyboard.currentHeight)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

