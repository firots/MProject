//
//  AddProjectButton.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: {
                    self.action?()
                }) {
                    Image(systemName: "plus")
                    .frame(width: 44, height: 44, alignment: .center)
                    .padding(0)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .shadow(color: .purple, radius: 4, x: 0, y: 0)

                }
                .foregroundColor(Color.purple)
                Spacer().frame(height: 24)
            }
            Spacer().frame(width: 24)
        }
    }
}

struct AddProjectButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
