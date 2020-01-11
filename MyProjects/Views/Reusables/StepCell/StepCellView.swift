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
    
    var body: some View {
        HStack {
            TextField("Name", text: $model.name)
        }
    }
}

struct StepCellView_Previews: PreviewProvider {
    static var previews: some View {
        StepCellView(model: StepCellViewModel(name: "", done: true, created: Date(), task: nil))
    }
}
