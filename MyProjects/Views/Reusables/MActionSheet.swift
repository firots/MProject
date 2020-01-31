//
//  MActionSheet.swift
//  MyProjects
//
//  Created by Firot on 31.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

struct MActionSheetViewModel {
    var show = false
    var title = ""
    var items = [MActionSheetItem]()
    
    init(show: Bool, title: String, items: [MActionSheetItem] ) {
        self.show = show
        self.title = title
        self.items = items
    }
    
    init() {
        
    }
}

struct MActionSheet: View {
    @Binding var model: MActionSheetViewModel
    
    var body: some View {
        ZStack {
            blurredOverlay()
            listItems()
        }
    }
    
    func listItems() -> some View {
        VStack() {
            ForEach(model.items) { itemModel in 
                self.item(itemModel: itemModel)
            }
        }.padding(.horizontal, 8)
        .cornerRadius(32)
            .transition(.move(edge: .bottom))
    }
    
    func item(itemModel: MActionSheetItem) -> some View {
        Button(action: {
            itemModel.action?()
            self.close()
        }) {
            VStack {
                HStack {
                    if itemModel.image != nil {
                        Image(uiImage: itemModel.image!)
                    }
                    Text(itemModel.text)
                        .font(.system(size: 18))
                }
            }.foregroundColor(Color(itemModel.color))
            .contentShape(Rectangle())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            

        }
    }
    
    func blurredOverlay() -> some View {
        ContentOverlay()
        .transition(.opacity)
        .onTapGesture {
            self.close()
        }
    }
    
    func close() {
        model = MActionSheetViewModel()
    }
}


struct MActionSheetItem: Identifiable {
    var id = UUID()
    var text: String
    var color: UIColor
    var image: UIImage?
    var action: (() -> Void)?
}
