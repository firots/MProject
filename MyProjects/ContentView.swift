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

    var body: some View {
        TabView {
            NavigationView {
                TasksView(project: nil)
            }
            .tabItem {
                Image(systemName: "largecircle.fill.circle")
                    .font(.system(size: 24))
            }.tag(0)
            
            NavigationView {
                ProjectsView()
            }
            .tabItem {
                Image(systemName: "tray.2")
                .font(.system(size: 24))
            }.tag(1)
            
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
                .font(.system(size: 24))
            }.tag(2)
        }.accentColor(Color(.systemPurple))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
