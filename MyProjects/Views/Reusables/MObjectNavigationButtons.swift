//
//  MObjectNavigationButtons.swift
//  MyProjects
//
//  Created by Firot on 15.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MObjectNavigationButtons: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)

            }
            
            Button(action: {
                
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }.padding(.trailing, 20)
    }
}

struct MObjectNavigationButtons_Previews: PreviewProvider {
    static var previews: some View {
        MObjectNavigationButtons()
    }
}
