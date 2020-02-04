//
//  LazyView.swift
//  MyProjects
//
//  Created by Firot on 4.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView(Text("hello"))
    }
}
