//
//  PurchaseView.swift
//  MyProjects
//
//  Created by Firot on 3.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct PurchaseView: View {
    @ObservedObject var model = PurchaseViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var animating = true
    
    var body: some View {
        VStack() {
            Text("MProject Premium")
                .font(.headline)
            
            Spacer()
                .frame(height: 20)
            
            logo()
            
            Spacer()
                .frame(height: 20)
            
            features()
            
            Spacer()
                .frame(height: 20)
            
            if model.loading {
                ActivityIndicator(isAnimating: $animating, style: UIActivityIndicatorView.Style.medium)
            } else {
                buyButton()
                 
                 Spacer()
                     .frame(height: 20)
                 
                 restoreButton()
            }

        }
        .padding()
        .frame(alignment: .center)
        .alert(isPresented: $model.showAlert) {
            Alert(title: Text(""), message: Text(model.message), dismissButton: .default(Text("Okay")) {
                if Settings.shared.pro == true {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    func restoreButton() -> some View {
        Button(action: {
            self.model.loading = true
            self.model.iAPHandler.restorePurchase()
        }) {
            Text("Restore Purchases")
                .foregroundColor(Color(.label))
                .underline()
                .padding()
        }
    }
    
    func buyButton() -> some View {
        Button(action: {
            self.model.loading = true
            self.model.iAPHandler.purchaseMyProduct(index: 0)
        }) {
            Text("Buy Premium \(model.price) ")
                .foregroundColor(Color(.white))
                .bold()
                .padding()
        }
        .background(Color(UIColor(netHex: 0xffb302)))
        .clipShape(Capsule())
    }
    
    func logo() -> some View {
        Image("mp_logo_gold")
            .renderingMode(.original)
            .resizable()
            .frame(width: 128, height: 128)
            .cornerRadius(25)
    }
    
    func features() -> some View {
        Group {
            Text("One time purchase")
                .padding()
            
            Text("Unlimited Tasks")
                .padding()

            Text("Unlimited Projects")
                .padding()
            
            Text("Free version is limited to 100 tasks and 10 projects. If you exceed this limit, you can continue to use app for free by deleting tasks and projects.")
                .font(.footnote)
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
