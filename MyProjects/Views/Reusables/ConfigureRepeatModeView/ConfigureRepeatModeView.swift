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
    let component = Calendar.current
    let monthDays = Array(1...31).map({ String($0) })
    
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
            } else if model.repeatMode == RepeatMode.week.rawValue {
                weeklyRepeat()
            } else if model.repeatMode == RepeatMode.month.rawValue {
                monthlyRepeat()
            }
        }
    }
    
    func hourlyRepeat() -> some View {
        var repeatDescription: String {
            model.repeatHoursPeriod > 1 ? "Repeats every \(model.repeatHoursPeriod) hours" : "Repeats every hour"
        }
        
        var intervalDescription: String {
            "When the minute of hour is: \(String(format: "%02d", model.repeatMinute))"
        }
        
        return Group {
            Section {
                Stepper(repeatDescription, value: $model.repeatHoursPeriod, in: 1...23)
            }
            
            Section {
                Stepper(intervalDescription, value: $model.repeatMinute, in: 0...59)
            }
            
        }
    }
    
    func dailyRepeat() -> some View {
        Section {
            Text("daily repeats")
        }
    }
    
    func weeklyRepeat() -> some View {
        ConfigureWeeklyView(selectedWeekDay: $model.selectedDayOfWeekIndex, repeatPeriod: $model.repeatWeeksPeriod, weekDays: component.shortWeekdaySymbols)
    }
    
    func startStopSection() -> some View {
        Group {
            Section(footer: Text("Send notifications only between specific date range.")) {
                Toggle(isOn: $model.hasStartStop) {
                    Text("Date Range")
                }
            }

            if model.hasStartStop {
                Section(header: Text("Start Date")) {
                    DateTimePicker(date: $model.startDate)
                }

                Section(header: Text("End Date")) {
                    DateTimePicker(date: $model.endDate)
                }
            }
        }
    }
    
    
    func monthlyRepeat() -> some View {
        ConfigureMonthlyView(selectedMonthDay: $model.selectedDayOfMonthIndex, repeatPeriod: $model.repeatMonthsPeriod, monthDays: monthDays)
    }
}





/*struct ConfigureRepeatModeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureRepeatModeView()
    }
}*/
