//
//  TopWarningView.swift
//  MyProjects
//
//  Created by Firot on 17.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct TopWarningView: View {
    @ObservedObject var model: TopWarningViewModel
    
    init(text: String, show: Bool) {
        model = TopWarningViewModel(text: text, show: show)
    }
    
    var body: some View {
        VStack() {
            if model.show {
                GeometryReader { geo in
                    HStack {
                        Spacer().frame(width: 20)
                        
                        Text(self.model.text)
                            .font(.footnote)
                            .foregroundColor(Color(.systemRed))
                        
                        Spacer().frame(width: 20)
                    }
                    .padding(.bottom, 5)
                    .frame(width: geo.size.width)
                    .background(Color(.systemBackground))
                    
                    Spacer()
                }
            }
            
        }
    }
}

struct TopWarningView_Previews: PreviewProvider {
    static var previews: some View {
        TopWarningView(text: "Hello World!", show: false)
    }
}

class TopWarningViewModel: ObservableObject {
    @Published var text: String
    @Published var show: Bool
    
    init(text: String, show: Bool) {
        self.text = text
        self.show = show
    }
}
