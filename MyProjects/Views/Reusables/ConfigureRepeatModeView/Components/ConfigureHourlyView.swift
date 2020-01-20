//
//  ConfigureHourlyView.swift
//  MyProjects
//
//  Created by Firot on 20.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI
import Foundation

struct ConfigureHourlyView: View {
    @Binding var repeatHoursPeriod: Int
    @Binding var repeatMinute: Int
    
    var body: some View {
        return Group {
            Section {
                Stepper(repeatDescription, value: $repeatHoursPeriod, in: 1...23)
            }
            
            Section {
                HStack {
                    CellImageView(systemName: "clock.fill")
                    Stepper(intervalDescription, value: $repeatMinute, in: 0...59)
                }
                
            }
        }
    }
    
    var repeatDescription: String {
        repeatHoursPeriod > 1 ? "Repeats every \(repeatHoursPeriod) hours" : "Repeats every hour"
    }
    
    var intervalDescription: String {
        return "At minute: \(String(format: "%02d", _repeatMinute.wrappedValue))"
    }
}

/*struct ConfigureHourlyView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureHourlyView()
    }
}*/
