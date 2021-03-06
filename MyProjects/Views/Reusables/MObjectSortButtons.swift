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
    let hasDetails: Bool
    @Binding var ascending: Bool
    @Binding var editMode: Bool
    @Binding var showDetails: Bool
    var sortAction: (() -> Void)?
    var filterAction: (() -> Void)?
    var purchaseAction: (() -> Void)?
    
    let buttonSize: CGFloat = 27
    
    var body: some View {
        HStack {
            if Settings.shared.isPro() == false {
                goldButton()
            }
            
            if hasDetails {
                detailButton()
            }
            
            editButton()
            setAscending()
            sortMObjects()
            if UIDevice.current.userInterfaceIdiom == .phone {
                filterMObjects()
            }
        }.padding(.top)
    }
    
    func goldButton() -> some View {
        Button(action: {
            self.purchaseAction?()
            
        }) {
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(Color(.systemRed))
        }
    }
    
    func editButton() -> some View {
        Group {
            if hasEdit {
                Button(action: {
                    withAnimation {
                        self.editMode.toggle()
                    }
                    
                }) {
                    Image(systemName: editMode ? "checkmark.circle.fill" : "pencil.circle.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                        .animation(.spring())
                        .foregroundColor(Color(editMode ? .systemBlue : .systemPurple))
                }
            }
        }
        
    }
    
    func detailButton() -> some View {
        Group {
            if hasEdit {
                Button(action: {
                    withAnimation {
                        self.showDetails.toggle()
                    }
                    
                }) {
                    Image(systemName: showDetails ? "info.circle.fill" : "info.circle")
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


