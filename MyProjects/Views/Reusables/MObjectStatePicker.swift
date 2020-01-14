//
//  MObjectStatePicker.swift
//  MyProjects
//
//  Created by Firot on 13.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MObjectStatePicker: View {
    @Binding var statusIndex: Int
    
    var body: some View {
        Picker(selection: $statusIndex.animation(), label: Text("Status")) {
            ForEach(0..<MObjectStatus.all.count) { index in
                Text(MObjectStatus.names[index].capitalizingFirstLetter())
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(MObjectStatus.colors[statusIndex])
        .cornerRadius(8)
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct MObjectStatePicker_Previews: PreviewProvider {
    @State static var statusIndex = 0
    static var previews: some View {
        MObjectStatePicker(statusIndex: $statusIndex)
    }
}
