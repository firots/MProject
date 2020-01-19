//
//  ConfigureMonthlyView.swift
//  MyProjects
//
//  Created by Firot on 19.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ConfigureMonthlyView: View {
    @Binding var selectedMonthDay: [Int]
    @Binding var repeatPeriod: Int
    let monthDays: [String]
    
    
    var body: some View {
        var repeatDescription: String {
            repeatPeriod > 1 ? "Repeats every \(repeatPeriod) month" : "Repeats every month"
        }

        return Group {
            Section {
                Stepper(repeatDescription, value: $repeatPeriod, in: 1...24)
            }
            
            Section {
                HStack {
                    Spacer()
                    MultiSelectorGridView(maxRows: nil, maxColumns: 7, maxSelection: nil, minSelection: 1, selections: $selectedMonthDay, items: monthDays, selectedColor: UIColor.systemPurple, selectedLabelColor: UIColor.systemBackground) {
                        
                    }
                    Spacer()
                }
            }
        }
    }
}
