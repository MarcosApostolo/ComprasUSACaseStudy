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
}
