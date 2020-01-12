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
    @State var showModal = false
    
    var body: some View {
        Group {
            addStepButton()
            ForEach(0..<model.steps.count, id: \.self) { index in
                StepCellView(model: self.model.steps[index]) {
                    _ = withAnimation {
                        self.model.steps.remove(at: index)
                    }
                }.onTapGesture {
                    self.model.newStep = false
                    self.model.stepViewModel = self.model.steps[index]
                    self.showModal = true
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        } .sheet(isPresented: $showModal) {
            AddStepView(model: self.model.stepViewModel, newStep: self.model.newStep) {
                self.model.steps.append(self.model.stepViewModel)
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
            CellImageView(systemName: "plus.circle")
            Text("Add New Step")
            Spacer()
        }
        .foregroundColor(Color(.systemPurple))
        .contentShape(Rectangle())
        .onTapGesture {
            self.model.newStep = true
            self.model.stepViewModel = StepCellViewModel(name: "")
            self.showModal = true
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
