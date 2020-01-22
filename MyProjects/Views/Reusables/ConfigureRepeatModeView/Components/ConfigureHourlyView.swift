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
    
    var body: some View {
        return Group {
            Section {
                Stepper(repeatDescription, value: $repeatHoursPeriod, in: 1...23)
            }
        }
    }
    
    var repeatDescription: String {
        repeatHoursPeriod > 1 ? "Repeats every \(repeatHoursPeriod) hours" : "Repeats every hour"
    }
}

/*struct ConfigureHourlyView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureHourlyView()
    }
}*/
