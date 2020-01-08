//
//  Placeholder.swift
//  MyProjects
//
//  Created by Firot on 8.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct PlaceholderView: View {
    @ObservedObject private var model: PlaceholderViewModel
    
    init(model: PlaceholderViewModel) {
        self.model = model
    }

    var body: some View {
        VStack() {
            Spacer()
            if model.image != nil {
                Image(uiImage: model.image!)
                Spacer().frame(height: 12)
            }
            
            Text(model.title ?? "").font(.title)
            Spacer().frame(height: 12)
            Text(model.subtitle ?? "").font(.subheadline).italic()
            Spacer()
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        let model = PlaceholderViewModel(title: "Hello There", subtitle: "This is an empty placeholder", image: UIImage(named: "pencil"))
        return PlaceholderView(model: model)
    }
}

class PlaceholderViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var title: String?
    @Published var subtitle: String?
    
    init(title: String?, subtitle: String?, image: UIImage?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}
