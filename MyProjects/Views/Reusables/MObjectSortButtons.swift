//
//  MObjectNavigationButtons.swift
//  MyProjects
//
//  Created by Firot on 15.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MObjectSortButtons: View {
    var sortAction: (() -> Void)?
    var filterAction: (() -> Void)?
    
    var body: some View {
        HStack {
            sortMObjects()
            filterMObjects()
        }.padding(.top)
            
    }
    
    func sortMObjects() -> some View {
        Button(action: {
            self.sortAction?()
        }) {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)

        }
    }
    
    func filterMObjects() -> some View {
        Button(action: {
            self.filterAction?()
        }) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}


