//
//  DateTimePicker.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct DateTimePicker: View {
    @Binding var date: Date
    
    
    var body: some View {
        Group {
            DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                Group {
                    CellImageView(systemName: "calendar.circle.fill")
                    Text("Date")
                }
            }
            .accentColor(Color(.systemPurple))

            DatePicker(selection: $date, in: Date()..., displayedComponents: .hourAndMinute) {
                Group {
                    CellImageView(systemName: "clock.fill")
                    Text("Time")
                }
            }
            .accentColor(Color(.systemPurple))
        }
    }
}

struct DateTimePickerLimitless: View {
    @Binding var date: Date
    
    var body: some View {
        Group {
            DatePicker(selection: $date, displayedComponents: .date) {
                Group {
                    CellImageView(systemName: "calendar.circle.fill")
                    Text("Start Date")
                }
            }
            .accentColor(Color(.systemPurple))

            DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
                Group {
                    CellImageView(systemName: "clock.fill")
                    Text("Start Time")
                }
            }
            .accentColor(Color(.systemPurple))
        }
    }
}

/*struct DateTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        DateTimePicker(date)
    }
}*/
