//
//  SettingsView.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var model: SettingsViewModel
    
    init() {
        model = SettingsViewModel()
    }
    var body: some View {
        NavigationView {
            Text("Settings will be here.")
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
