//
//  CellImageView.swift
//  MyProjects
//
//  Created by Firot on 13.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct CellImageView: View {
    @State var systemName: String
    var body: some View {
        Group {
            Image(systemName: systemName)
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(Color(.systemPurple))
                .padding(.trailing, 6)
        }

    }
}

struct CellImageView_Previews: PreviewProvider {
    static var previews: some View {
        CellImageView(systemName: "gear")
    }
}
