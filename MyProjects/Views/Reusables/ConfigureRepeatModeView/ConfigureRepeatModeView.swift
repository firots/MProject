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
    @State private var weekDays = [0]
    let component = Calendar.current
    
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
            model.repeatPeriod > 1 ? "Repeats every \(model.repeatPeriod) hours" : "Repeats every hour"
        }
        
        var intervalDescription: String {
            "When the minute of hour is: \(String(format: "%02d", model.repeatInterval))"
        }
        
        return Group {
            Section {
                Stepper(repeatDescription, value: $model.repeatPeriod.animation(), in: 1...23)
            }
            
            Section {
                Stepper(intervalDescription, value: $model.repeatInterval.animation(), in: 0...59)
            }
            
        }
    }
    
    func dailyRepeat() -> some View {
        Section {
            Text("daily repeats")
        }
    }
    
    func weeklyRepeat() -> some View {
        var repeatDescription: String {
            model.repeatPeriod > 1 ? "Repeats every \(model.repeatPeriod) day" : "Repeats every week"
        }
        
        let component = Calendar.current

        
        var intervalDescription: String {
            "When the day of week is: \(String(format: "%02d", model.repeatInterval))"
        }
        


        
        return Group {
            Section {
                HStack {
                    Spacer()
                    MultiSelectorGridView(maxRows: nil, maxColumns: 7, maxSelection: nil, minSelection: 1, selections: $weekDays, items: component.shortWeekdaySymbols, selectedColor: UIColor.systemPurple, selectedLabelColor: UIColor.systemBackground) {
                        
                    }
                    Spacer()
                }
            }
        }
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
