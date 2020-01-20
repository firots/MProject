//
//  ConfigureDailyView.swift
//  MyProjects
//
//  Created by Firot on 20.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ConfigureDailyView: View {
    @Binding var repeatDaysPeriod: Int
    
    var body: some View {
        var repeatDescription: String {
            repeatDaysPeriod > 1 ? "Repeats every \(repeatDaysPeriod) days" : "Repeats every day"
        }
        
        return Section {
            Stepper(repeatDescription, value: $repeatDaysPeriod, in: 1...30)
        }
    }
}

/*struct ConfigureDailyView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureDailyView()
    }
}*/
