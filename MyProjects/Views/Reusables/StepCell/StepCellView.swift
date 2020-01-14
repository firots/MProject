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
    @Environment(\.editMode) var editMode
    
    var tapAction: (() -> Void)?
    
    var body: some View {
        HStack {
            checkerButton()
            Text(model.name.emptyHolder("Unnamed Step"))
                .strikethrough(model.statusIndex == 1)
            .lineLimit(3)
            Spacer()
        }.contentShape(Rectangle())
        .onTapGesture {
            self.tapAction?()
        }
    }
    
    func checkerButton() -> some View {
        ZStack {
            CellImageView(systemName: "circle")
            if model.statusIndex == 1 {
                Image(systemName: self.model.statusIndex == 0 ? "circle" : "checkmark.circle.fill")
                .resizable()
                .frame(width:24, height: 24)
                .padding(.trailing, 6)
                .foregroundColor(self.model.statusIndex == 0 ? Color(.systemPurple) : Color(.systemGreen))
                .transition(.scale)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                self.model.statusIndex = self.model.statusIndex == 0 ? 1 : 0
            }
        }
    }
}


/*struct StepCellView_Previews: PreviewProvider {
    static var previews: some View {
        StepCellView(model: StepCellViewModel(name: "", done: true, created: Date()))
    }
}*/
