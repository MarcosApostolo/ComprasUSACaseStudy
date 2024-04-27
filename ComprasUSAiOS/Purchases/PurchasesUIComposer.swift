//
//  PurchasesUIComposer.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation
import ComprasUSACaseStudy

public class PurchasesUIComposer {
    private init() {}
    
    public static func composePurchasesList(loader: PurchaseLoader) -> PurchasesListViewController {
        let vc = PurchasesListViewController()
        let viewModel = PurchasesListViewModel(loader: loader)
        
        vc.viewModel = viewModel
        
        return vc
    }
}
