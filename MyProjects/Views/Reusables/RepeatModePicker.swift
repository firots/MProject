//
//  RepeatModePicker.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct RepeatModePicker<T: HasRepeatMode>: View {
    @Binding var model: ConfigureRepeatModeViewModel<T>
    var desc: String
    
    var body: some View {
        VStack {
            Picker(selection: $model.repeatMode.animation(), label: Text("Status")) {
                ForEach(0..<RepeatMode.all.count) { index in
                    Text(RepeatMode.names[index].capitalizingFirstLetter())
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Text(RepeatMode.descriptions[model.repeatMode])
                .font(.footnote)
        }

    }
}
