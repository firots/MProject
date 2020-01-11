//
//  StepCellView.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct StepCellView: View {
    @ObservedObject var model: StepCellViewModel
    
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            TextView(text: $model.name, isEditing: $model.editing, backgroundColor: .systemBackground, isScrollingEnabled: false)

            Spacer()
            
            Button(action: {
                self.action?()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.systemPurple))
            }
        }
    }
}

struct StepCellView_Previews: PreviewProvider {
    static var previews: some View {
        StepCellView(model: StepCellViewModel(name: "", done: true, created: Date(), task: nil))
    }
}
