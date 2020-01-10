//
//  TickCircleView.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct CheckmarkButton: View {
    @ObservedObject var model: CheckmarkButtonViewModel
    
    var body: some View {
        let status = model.status
        return Button(action: {
            self.model.action?()
        }) {
            if status == .active {
                checkmarkButtonImage(imageName: "circle")
            } else if status == .done {
                checkmarkButtonImage(imageName: "checkmark.circle.fill")
                .foregroundColor(Color(.systemGreen))
            } else if status == .waiting {
                checkmarkButtonImage(imageName: "pause.circle.fill")
                    .foregroundColor(Color(.systemOrange))
            } else {
                checkmarkButtonImage(imageName: "xmark.circle.fill")
                    .foregroundColor(Color(.systemPink))
            }
        }
    }
    
    func checkmarkButtonImage(imageName: String) -> some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 30, height: 30)
            .aspectRatio(contentMode: .fill)
    }
    
    init(status: MObjectStatus, action: (() -> Void)?) {
        self.model = CheckmarkButtonViewModel(status: status, action: action)
    }
}

struct CheckmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckmarkButton(status: .active) {
            
        }
    }
}

class CheckmarkButtonViewModel: ObservableObject {
    @Published var status: MObjectStatus
    var action: (() -> Void)?
    
    init(status: MObjectStatus, action: (() -> Void)?) {
        self.status = status
        self.action = action
    }
}
