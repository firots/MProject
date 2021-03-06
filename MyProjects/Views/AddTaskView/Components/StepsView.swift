//
//  StepsView.swift
//  MyProjects
//
//  Created by Firot on 11.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct StepsView: View {
    @ObservedObject var model: StepsViewModel
    @State var isEditing = false
    var modalAction: (() -> Void)?
    
    init(model: StepsViewModel, modalAction: (() -> Void)?) {
        self.model = model
        self.modalAction = modalAction
    }
    
    var body: some View {
        Group {
            Section {
                addStepButton()
            }
            if model.steps.count > 0 {
                Section {
                    ForEach(model.steps) { step in
                        VStack {
                            StepCellView(model: step) {
                                withAnimation {
                                    self.model.newStep = false
                                    self.model.stepViewModel = step
                                    self.modalAction?()
                                }
                            }
                        }.contentShape(Rectangle())
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.steps.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        model.steps.remove(atOffsets: offsets)
    }
    
    func addStepButton() -> some View {
        HStack {
            CellImageView(systemName: "plus.circle.fill")
            Text("Add New Step")
            Spacer()
        }
        .foregroundColor(Color(.systemPurple))
        .contentShape(Rectangle())
        .onTapGesture {
            self.model.newStep = true
            self.model.stepViewModel = StepCellViewModel(name: "")
            self.modalAction?()
        }
    }
}


class StepsViewModel: ObservableObject {
    @Published var steps = [StepCellViewModel]()
    var stepViewModel = StepCellViewModel(name: "")
    var newStep = false
    
    init(steps: [StepCellViewModel]) {
        self.steps = steps
    }
}



/*struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}*/
