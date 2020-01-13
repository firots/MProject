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
    
    var tapAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer().frame(width: 37)
            Text(model.name.emptyHolder("Unnamed Step"))
            .lineLimit(3)
            Spacer()
        }.contentShape(Rectangle())
        .onTapGesture {
            print("sdfdsf")
            self.tapAction?()
        }
    }
}

/*struct StepCellView_Previews: PreviewProvider {
    static var previews: some View {
        StepCellView(model: StepCellViewModel(name: "", done: true, created: Date()))
    }
}*/
