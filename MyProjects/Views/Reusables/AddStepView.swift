//
//  AddStepView.swift
//  MyProjects
//
//  Created by Firot on 13.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddStepView: View {
    @ObservedObject var model: StepCellViewModel
    @State var jenas = true
    @Environment(\.presentationMode) var presentationMode
    var newStep: Bool
    @ObservedObject var keyboard: KeyboardResponder
    var addAction: (() -> Void)?
    

    var body: some View {
        VStack {
            ZStack {
                ModalTitle(title: newStep ? "Add New Step" : "Edit Step", edit: false) {
                    if self.newStep { self.addAction?() }
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                KeyboardDoneButton(show: $jenas)
            }
            self.statePicker()
            TextView(text: $model.name, isEditing: $jenas)
        }
        .edgesIgnoringSafeArea(.bottom)
        .padding(.bottom, keyboard.currentHeight)
    }
    
    func statePicker() -> some View {
        Picker(selection: $model.statusIndex.animation(), label: Text("Status")) {
            ForEach(0..<2) { index in
                Text(MStepStatus.all[index].rawValue.capitalizingFirstLetter())
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(MStepStatus.colors[model.statusIndex])
        .cornerRadius(8)
        .padding(.horizontal, 20)
    }
}
