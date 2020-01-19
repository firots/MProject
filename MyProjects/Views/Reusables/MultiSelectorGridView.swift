//
//  MultiSelectorGridView.swift
//  MultiSelectorGridView
//
//  Created by Firot on 19.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MultiSelectorGridView: View {
    @ObservedObject private var model: MultiSelectorGridViewModel
    
    let selectedColor: UIColor
    let selectedLabelColor: UIColor
    
    var action: (() -> Void)?
    
    init(maxRows: Int?, maxColumns: Int?, maxSelection: Int?, minSelection: Int?, selections: Binding<[Int]>, items: [String], selectedColor: UIColor, selectedLabelColor: UIColor, action: (() -> Void)?) {
        self.model = MultiSelectorGridViewModel(maxRows, maxColumns, maxSelection, minSelection, items, selections)
        self.selectedColor = selectedColor
        self.selectedLabelColor = selectedLabelColor
    }
    
    var body: some View {
        HStack (alignment: .top) {
            ForEach(0..<self.model.columns) { column in
                VStack (alignment: .center) {
                    ForEach(0..<self.model.rows) { row in
                        self.cell(column + row * self.model.columns)
                    }
                }
            }
        }
    }
    
    private func cell(_ i: Int) -> some View {
        Group {
            if model.items.count > i {
                ZStack {
                    self.selectedBackground(i)
                        .scaledToFill()
                    
                    Text(self.model.items[i])
                        .foregroundColor(self.isSelected(i) ? Color(selectedLabelColor) : Color(.label))
                }
                .frame(width: 40, height: 40)
                .onTapGesture {
                    self.onTap(i)
                }
            }
        }
    }
    
    private func onTap(_ i: Int) {
        withAnimation {
            if self.isSelected(i) {
                if self.model.selections.wrappedValue.count > self.model.minSelection {
                    self.model.selections.wrappedValue.removeAll(where: {$0 == i})
                }
            } else {
                if self.model.selections.wrappedValue.count < self.model.maxSelection {
                    self.model.selections.wrappedValue.append(i)
                }
            }
        }
    }
    
    private func selectedBackground(_ i: Int) -> some View {
        Group {
            if isSelected(i) {
                Circle()
                    .fill(Color(selectedColor))
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    private func isSelected(_ i: Int) -> Bool {
        model.selections.wrappedValue.contains(i)
    }
}

struct MultiSelectorGridView_Previews: PreviewProvider {
    @State static var selections = [1, 5]
    static var previews: some View {
        MultiSelectorGridView(maxRows: 5, maxColumns: 5, maxSelection: 1, minSelection: nil, selections: $selections, items: ["1", "2", "3", "4","5","6", "7", "8", "9","10","11", "12", "13", "14","15"], selectedColor: UIColor.red, selectedLabelColor: UIColor.systemBackground) {
        }
    }
}


class MultiSelectorGridViewModel: ObservableObject {
    let maxRows: Int
    let maxColumns: Int
    let maxSelection: Int
    let minSelection: Int
    let items: [String]
    
    @Published var selections: Binding<[Int]>
    
    init(_ maxRows: Int?, _ maxColumns: Int?, _ maxSelection: Int?, _ minSelection: Int?, _ items: [String], _ selections: Binding<[Int]>) {
        self.maxRows = maxRows ?? Int.max
        self.maxColumns = maxColumns ?? Int.max
        self.maxSelection = maxSelection ?? Int.max
        self.minSelection = minSelection ?? 0
        self.items = items
        self.selections = selections
    }
    
    var columns: Int {
        items.count >= maxColumns ? maxColumns : items.count
    }
    
    var rows: Int {
        items.count / columns + items.count % columns
    }
    

}

