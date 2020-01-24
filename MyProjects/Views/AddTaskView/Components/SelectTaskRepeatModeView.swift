//
//  SelectTaskRepeatModeView.swift
//  MyProjects
//
//  Created by Firot on 24.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct SelectTaskRepeatModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: SelectTaskRepeatModeViewModel
    @ObservedObject var keyboard: KeyboardResponder
    
    init(taskModel: AddTaskViewModel, keyboard: KeyboardResponder) {
        self.keyboard = keyboard
        self.model = SelectTaskRepeatModeViewModel(taskModel: taskModel)
    }
    
    var body: some View {
        VStack {
            titleBar()
            
            RepeatModePicker(model: $model.taskModel.repeatModeConfiguration, desc: RepeatMode.descriptions[model.taskModel.repeatModeConfiguration.repeatMode])
            
            Form {
                if model.taskModel.repeatModeConfiguration.repeatMode != RepeatMode.none.rawValue {
                    ConfigureRepeatModeView(model: $model.taskModel.repeatModeConfiguration)
                }
            }
            .padding(.bottom, keyboard.currentHeight)
            .background(Color(.systemGroupedBackground))
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    func titleBar() -> some View {
        ModalTitle(title: "Set Repeat Mode", edit: false) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

class SelectTaskRepeatModeViewModel: ObservableObject {
    @Published var taskModel: AddTaskViewModel
    
    init(taskModel: AddTaskViewModel) {
        self.taskModel = taskModel
    }
}




