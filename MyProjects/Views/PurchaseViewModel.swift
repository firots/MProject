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
    var alertType = IAPHandlerAlertType.disabled
    
    init() {
        IAP()
    }
    
    func productRequested(id: String, price: String) {
        loading = false
    }
    
    func productRequestEnded() {
        loading = false
    }
    
    func IAP() {
        IAPHandler.shared.delegate = self
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            if type == .purchased {
                self?.alertType = .purchased
                Settings.shared.pro = true
            } else if type == .restored {
                self?.alertType = .purchased
                Settings.shared.pro = true
            } else if type == .failed {
                self?.alertType = .failed
            }
        }
    }
    
}
