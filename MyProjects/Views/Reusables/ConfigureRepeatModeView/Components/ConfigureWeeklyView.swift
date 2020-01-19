//
//  ConfigureWeeklyView.swift
//  MyProjects
//
//  Created by Firot on 19.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ConfigureWeeklyView: View {
    @Binding var selectedWeekDay: [Int]
    @Binding var repeatPeriod: Int
    let weekDays: [String]
    
    
    var body: some View {
        var repeatDescription: String {
            repeatPeriod > 1 ? "Repeats every \(repeatPeriod) weeks" : "Repeats every week"
        }

        return Group {
            Section {
                Stepper(repeatDescription, value: $repeatPeriod, in: 1...20)
            }
            
            Section {
                HStack {
                    Spacer()
                    MultiSelectorGridView(maxRows: 1, maxColumns: 7, maxSelection: nil, minSelection: 1, selections: $selectedWeekDay, items: weekDays, selectedColor: UIColor.systemPurple, selectedLabelColor: UIColor.systemBackground) {
                        
                    }
                    Spacer()
                }
            }
        }
    }
}
