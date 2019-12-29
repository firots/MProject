//
//  ContentView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MyProjectsView()
            .tabItem {
                Image(systemName: "briefcase")
                .font(.system(size: 24))
            }.tag(0)
            
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
                .font(.system(size: 24))
            }.tag(1)
        }.accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
