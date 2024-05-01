//
//  CreatePurchaseViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation

class RegisterPurchaseViewModel {
    var title: String {
        NSLocalizedString(
            "REGISTER_PURCHASE_TITLE",
            tableName: "Purchase",
            bundle: Bundle(for: RegisterPurchaseViewController.self), 
            comment: "Title for the Create Purchase page"
        )
    }
    
    var productNameTextFieldPlaceholder: String {
        NSLocalizedString(
            "REGISTER_PURCHASE_PRODUCT_NAME_PLACEHOLDER_LABEL",
            tableName: "Purchase",
            bundle: Bundle(for: RegisterPurchaseViewController.self),
            comment: "Placeholder label for the product name text field"
        )
    }
    
    var valueTextFieldPlaceholder: String {
        NSLocalizedString(
            "REGISTER_PURCHASE_VALUE_PLACEHOLDER_LABEL",
            tableName: "Purchase",
            bundle: Bundle(for: RegisterPurchaseViewController.self),
            comment: "Placeholder label for the value text field"
        )
    }
    
    var genericRequiredError: String {
        NSLocalizedString(
            "REGISTER_PURCHASE_GENERIC_REQUIRED_ERROR_LABEL",
            tableName: "Purchase",
            bundle: Bundle(for: RegisterPurchaseViewController.self),
            comment: "Placeholder label for the value text field"
        )
    }
}
