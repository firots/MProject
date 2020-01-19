//
//  ConfigureRepeatModeView.swift
//  MyProjects
//
//  Created by Firot on 18.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ConfigureRepeatModeView<T: HasRepeatMode>: View {
    @Binding var model: ConfigureRepeatModeViewModel<T>
    
    var body: some View {
        Group {
            mainSection()
            startStopSection()
        }
        
    }
    
    func mainSection() -> some View {
        Group {
            if model.repeatMode == RepeatMode.hour.rawValue {
                hourlyRepeat()
            } else if model.repeatMode == RepeatMode.day.rawValue {
                dailyRepeat()
            } else if model.repeatMode == RepeatMode.dow.rawValue {
                weeklyRepeat()
            } else if model.repeatMode == RepeatMode.dom.rawValue {
                monthlyRepeat()
            }
        }
    }
    
    func hourlyRepeat() -> some View {
        Section {
            Text("Repeats Hourly")
        }
    }
    
    func startStopSection() -> some View {
        Group {
            Section(footer: Text("Send notifications only between start and end dates")) {
                Toggle(isOn: $model.hasStartStop) {
                    Text("Date Range")
                }
            }

            if model.hasStartStop {
                Section {
                    HStack {
                        CellImageView(systemName: "play.circle.fill")
                        Text("Start Date")
                    }
                    
                    DateTimePicker(date: $model.startDate)
                }

                Section {
                    HStack {
                        CellImageView(systemName: "stop.circle.fill")
                        Text("End Date")
                    }
                    DateTimePicker(date: $model.endDate)
                }
            }
        }
    }
    
    func dailyRepeat() -> some View {
        Section {
            Text("Repeats Daily")
            Text("Repeats Daily")
        }
    }
    
    func weeklyRepeat() -> some View {
        Section {
            Text("Repeats Day of Week")
            Text("Repeats Day of Week")
            Text("Repeats Day of Week")
        }
    }
    
    func monthlyRepeat() -> some View {
        Group {
            Text("Repeats Day of Month")
            Text("Repeats Day of Month")
            Text("Repeats Day of Month")
            Text("Repeats Day of Month")
        }
    }
}

/*struct ConfigureRepeatModeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureRepeatModeView()
    }
}*/
