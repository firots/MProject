//
//  SplashScreen.swift
//  MyProjects
//
//  Created by Firot on 5.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Group {
            Image("mp_logo_white")
                .resizable()
                .frame(width: 256, height: 256)
                .colorMultiply(Color(.systemPurple))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
            

    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
