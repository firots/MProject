//
//  AddMObjectView.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddMObjectView<T>: View where T: MObject {
    @ObservedObject private var model: AddMObjectViewModel<T>
    
    init(model: AddMObjectViewModel<T>) {
        self.model = model
    }
    
    var body: some View {
        mainSection()
    }
    
    private func taskStatePicker() -> some View {
        Picker(selection: $model.statusIndex, label: Text("Status")) {
            ForEach(0..<MObjectStatus.all.count) { index in
                Text(MObjectStatus.all[index].rawValue.capitalizingFirstLetter())
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(MObjectStatus.colors[model.statusIndex])
        .cornerRadius(5)
    }
    
    func mainSection() -> some View {
        Section {
            taskStatePicker()
            TextField("Name of your project", text: $model.name)
            
            TextField("Details about your project (optional)", text: $model.details)
            
            Toggle(isOn: $model.hasDeadline.animation()) {
                Text("Set a deadline for this project")
            }
            
            if model.hasDeadline {
                DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .date) {
                    Text("Date")
                }.accentColor(.purple)
                
                DatePicker(selection: $model.deadline, in: Date()..., displayedComponents: .hourAndMinute) {
                    Text("Time")
                }.accentColor(.purple)
            }
        }
    }
}

/*struct AddMObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMObjectView()
    }
}*/
