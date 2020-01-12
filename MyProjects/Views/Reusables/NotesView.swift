//
//  NotesView.swift
//  MyProjects
//
//  Created by Firot on 9.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var model: NotesViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
    @Environment(\.presentationMode) var presentationMode
    
    init(model: NotesViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            ModalTitle(title: "Details", edit: false) {
                self.presentationMode.wrappedValue.dismiss()
                self.model.notes.wrappedValue = self.model.tempNotes
            }
            TextView(text: $model.tempNotes, isEditing: $model.isEditing)
        }
        .padding(.bottom, keyboard.currentHeight)
    }
}

struct NotesView_Previews: PreviewProvider {
    @State private static var notes = "Hello Warudo"
    @ObservedObject private static var model = NotesViewModel(notes: $notes)
    static var previews: some View {
        NotesView(model: model)
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: Binding<String>
    @Published var tempNotes: String
    @State var isEditing = true
    
    init(notes: Binding<String>) {
        self.notes = notes
        self.tempNotes = notes.wrappedValue
    }
}
