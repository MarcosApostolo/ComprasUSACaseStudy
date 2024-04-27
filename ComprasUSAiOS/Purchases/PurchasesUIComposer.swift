//
//  PurchasesUIComposer.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation

public class PurchasesUIComposer {
    private init() {}
    
    public static func composePurchasesList() -> PurchasesListViewController {
        let vc = PurchasesListViewController()
        let viewModel = PurchasesListViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
