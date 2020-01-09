//
//  View+HideKeyboard.swift
//  MyProjects
//
//  Created by Firot on 7.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard()
    {
        
    }
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View { content
        .onTapGesture(count: 2){}
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 0, pressing: nil, perform: { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) })
    }
}
