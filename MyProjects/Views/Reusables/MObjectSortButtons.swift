//
//  MObjectNavigationButtons.swift
//  MyProjects
//
//  Created by Firot on 15.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MObjectSortButtons: View {
    var body: some View {
        VStack {
            sortMObjects()
            filterMObjects()
        }
        .padding(.trailing, 20)
    }
    
    func sortMObjects() -> some View {
        Button(action: {
            
        }) {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)

        }
    }
    
    func filterMObjects() -> some View {
        Button(action: {
            
        }) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
    
    
    


enum MObjectSorter: Int {
    case none
    case priority
    case alphabetic
    case creation
    case started
    case deadline
    
    static let all = [MObjectSorter.none, MObjectSorter.priority, MObjectSorter.alphabetic, MObjectSorter.creation, MObjectSorter.started, MObjectSorter.deadline]
    
    static var names = ["None", "Priority", "Alphabetic", "Date Created", "Date Started", "Deadline"]
}

struct MObjectSortButtons_Previews: PreviewProvider {
    static var previews: some View {
        MObjectSortButtons()
    }
}
