//
//  CircularProgressBar.swift
//  MyProjects
//
//  Created by Firot on 23.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct CircularProgressBarView: View {
    @ObservedObject var model: CircularProgressBarViewModel
    
    init(color: UIColor, text: String, width: CGFloat, thickness: CGFloat, progress: CGFloat) {
        model = CircularProgressBarViewModel(color, text, width, thickness, progress)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(model.color), lineWidth: model.thickness)
                .opacity(0.3)
                .frame(width: model.width, height: model.width)
            Text(model.text)
            Circle()
                .trim(from: 0, to: model.progress)
                .stroke(Color(model.color), style: StrokeStyle(lineWidth: model.thickness, lineCap: .round))
                .animation(.linear(duration: 0.4))
                .frame(width: model.width, height: model.width)
                .rotationEffect(Angle(degrees:-90))
        }
    }
}

class CircularProgressBarViewModel: ObservableObject {
    @Published var color: UIColor
    @Published var text: String
    @Published var progress = CGFloat.zero
    let width: CGFloat
    let thickness: CGFloat
    
    init(_ color: UIColor, _ text: String, _ width: CGFloat, _ thickness: CGFloat, _ progress: CGFloat) {
        self.color = color
        self.text = text
        self.width = width
        self.thickness = thickness
        self.progress = progress
    }
    
}
