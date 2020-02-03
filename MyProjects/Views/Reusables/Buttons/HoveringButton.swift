//
//  AddProjectButton.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct HoveringButton: View {
    var action: (() -> Void)?
    let color: Color
    let image: Image

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button(action: {
                    self.action?()
                }) {
                    image
                    .frame(width: 44, height: 44, alignment: .center)
                    .padding(0)
                    .background(color)
                    .clipShape(Circle())
                    .shadow(color: color, radius: 4, x: 0, y: 0)

                }
                .foregroundColor(Color(.systemBackground))
                Spacer().frame(height: 24)
            }
            Spacer().frame(width: 24)
        }
    }
    
    init(color: Color, image: Image, action: (() -> Void)?) {
        self.color = color
        self.image = image
        self.action = action
    }
}

struct HoveringButton_Previews: PreviewProvider {
    static var previews: some View {
        HoveringButton(color: Color(.systemPurple), image: Image(systemName: "plus")) {
            
        }
    }
}
