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
            if model.repeatMode != RepeatMode.hour.rawValue {
                timePicker()
            }
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
        ConfigureHourlyView(repeatHoursPeriod: $model.repeatHoursPeriod, repeatMinute: $model.repeatMinute)
    }
    
    func dailyRepeat() -> some View {
        ConfigureDailyView(repeatDaysPeriod: $model.repeatDaysPeriod)
    }
    
    func weeklyRepeat() -> some View {
        ConfigureWeeklyView(selectedWeekDay: $model.selectedDayOfWeekIndex, repeatPeriod: $model.repeatWeeksPeriod, weekDays: component.shortWeekdaySymbols)
    }
    
    func startStopSection() -> some View {
        Group {
            Section(footer: Text("Repeats only between start and end dates.")) {
                HStack {
                    CellImageView(systemName: "calendar.circle.fill")
                    Toggle(isOn: $model.hasStartStop) {
                        Text("Date Range")
                    }
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
    
    func timePicker() -> some View {
        DatePicker(selection: $model.timeDate, in: Date()..., displayedComponents: .hourAndMinute) {
            Group {
                CellImageView(systemName: "clock.fill")
                Text("When the time is")
            }
        }
        .accentColor(Color(.systemPurple))
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
