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
    
    var body: some View {
        Group {
            addStepButton()
            ForEach(0..<model.steps.count, id: \.self) { index in
                StepCellView(model: self.model.steps[index]) {
                    _ = withAnimation {
                        self.model.steps.remove(at: index)
                    }
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.steps.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        model.steps.remove(atOffsets: offsets)
    }
    
    func addStepButton() -> some View {
        Button(action: {
            let stepModel = StepCellViewModel(name: "", done: false, created: Date())
            stepModel.name = String(self.model.steps.count)
            withAnimation {
                self.model.steps.append(stepModel)
            }
        }) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Step")
            }
        }.accentColor(Color(.systemPurple))
    }
}


class StepsViewModel: ObservableObject {
    @Published var steps = [StepCellViewModel]()
    
    init(steps: [StepCellViewModel]) {
        self.steps = steps
    }
}



/*struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}*/
