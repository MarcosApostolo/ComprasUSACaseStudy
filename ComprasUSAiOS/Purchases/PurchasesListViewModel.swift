//
//  PurchasesListViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation

class PurchasesListViewModel {
    static var title: String {
        return NSLocalizedString("PURCHASES_TITLE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Title for the purchases view")
    }
}
