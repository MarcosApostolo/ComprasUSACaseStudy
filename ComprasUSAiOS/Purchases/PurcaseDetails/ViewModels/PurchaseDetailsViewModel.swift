//
//  PurchaseDetailsViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import ComprasUSACaseStudy

class PurchaseDetailsViewModel {
    private var model: Purchase
    
    public init(model: Purchase) {
        self.model = model
    }
    
    var productNameLabel: String {
        return NSLocalizedString("PURCHASE_DETAIL_PRODUCT_NAME",
            tableName: "Purchase",
            bundle: Bundle(for: PurchaseDetailsViewController.self),
            comment: "Label for the product name")
    }
}
