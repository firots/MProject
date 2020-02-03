//
//  MObjectNavigationButtons.swift
//  MyProjects
//
//  Created by Firot on 15.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct MObjectSortButtons: View {
    let hasEdit: Bool
    @Binding var ascending: Bool
    @Binding var editMode: Bool
    var sortAction: (() -> Void)?
    var filterAction: (() -> Void)?
    var editAction: (() -> Void)?
    
    let buttonSize: CGFloat = 27
    
    var body: some View {
        HStack {
            editButton()
            setAscending()
            sortMObjects()
            if UIDevice.current.userInterfaceIdiom == .phone {
                filterMObjects()
            }

        }.padding(.top)
            
    }
    
    func editButton() -> some View {
        Group {
            if hasEdit {
                Button(action: {
                    withAnimation {
                        self.editMode.toggle()
                    }
                    
                }) {
                    Image(systemName: editMode ? "pencil.circle.fill" : "pencil.circle")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                        .animation(.spring())
                }
            }
        }
        
    }
    
    func setAscending() -> some View {
        Button(action: {
            withAnimation {
                self.ascending.toggle()
            }
            
        }) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .rotationEffect(ascending ? .degrees(0) : .degrees(180))
                .animation(.spring())

        }
    }
    
    func sortMObjects() -> some View {
        Button(action: {
            self.sortAction?()
        }) {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)

        }
    }
    
    func filterMObjects() -> some View {
        Button(action: {
            self.filterAction?()
        }) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
        }
    }
}


