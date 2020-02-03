//
//  PurchaseViewModel.swift
//  MyProjects
//
//  Created by Firot on 3.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class PurchaseViewModel: ObservableObject, IAPHandlerDelegate {
    @Published var showAlert = false
    @Published var loading = true
    @Published var price = ""
    
    @Published var message = ""
    
    lazy var iAPHandler = IAPHandler()
    
    init() {
        IAP()
    }
    
    func productRequested(id: String, price: String) {
        DispatchQueue.main.async {
            self.loading = false
            self.price = price
        }
        
    }
    
    func productRequestEnded() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    func IAP() {
        iAPHandler.delegate = self
        iAPHandler.fetchAvailableProducts()
        iAPHandler.purchaseStatusBlock = {type in
            DispatchQueue.main.async {
                if type == .purchased {
                    self.message = type.message()
                    Settings.shared.pro = true
                    self.showAlert = true
                } else if type == .restored {
                    self.message = type.message()
                    Settings.shared.pro = true
                    self.showAlert = true
                } else if type == .failed {
                    self.message = type.message()
                    self.showAlert = true
                }
            }
        }
    }
    
}
