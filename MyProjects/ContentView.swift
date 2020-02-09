//
//  ContentView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    let timer = Timer.publish(every: 59, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView {
            NavigationView {
                TasksView(project: nil, pCellViewModel: nil)
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "largecircle.fill.circle")
                    .font(.system(size: 24))
            }.tag(0)
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationView {
                    ProjectsView()
                }.navigationViewStyle(DoubleColumnNavigationViewStyle())
                .tabItem {
                    Image(systemName: "tray.2")
                    .font(.system(size: 24))
                }.tag(1)
            } else {
                NavigationView {
                    ProjectsView()
                }.navigationViewStyle(DoubleColumnNavigationViewStyle())
                    .padding()
                .tabItem {
                    Image(systemName: "tray.2")
                    .font(.system(size: 24))
                }.tag(1)
            }
            

            
            /*SettingsView()
            .tabItem {
                Image(systemName: "gear")
                .font(.system(size: 24))
            }.tag(2)*/
        }.accentColor(Color(.systemPurple))
            .onAppear() {
                LocalNotifications.shared.register()
        }
        .onReceive(timer) { _ in
            let dm = DataManager(isViewContext: false)
            dm.start()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



