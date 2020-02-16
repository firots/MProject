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
    let text: String
    
    
    var body: some View {
        Group {
            DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                Group {
                    CellImageView(systemName: "calendar.circle.fill")
                    Text(text)
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

struct DateTimePickerLast24: View {
    @Binding var date: Date
    let text: String
    
    var body: some View {
        var minDate = Date()
        minDate.addHours(-24)
        return Group {
            DatePicker(selection: $date, in: minDate..., displayedComponents: .date) {
                Group {
                    CellImageView(systemName: "calendar.circle.fill")
                    Text(text)
                }
            }
            .accentColor(Color(.systemPurple))

            DatePicker(selection: $date, in: minDate..., displayedComponents: .hourAndMinute) {
                Group {
                    CellImageView(systemName: "clock.fill")
                    Text("Repeat Start Time")
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
