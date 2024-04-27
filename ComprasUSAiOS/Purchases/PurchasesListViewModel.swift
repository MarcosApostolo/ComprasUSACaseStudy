//
//  PurchasesListViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation
import ComprasUSACaseStudy

class PurchasesListViewModel {
    private let loader: PurchaseLoader
    
    var title: String {
        return NSLocalizedString("PURCHASES_TITLE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Title for the purchases view")
    }
    
    init(loader: PurchaseLoader) {
        self.loader = loader
    }
    
    func loadPurchases() {
        loader.load(completion: { _ in })
    }
}
