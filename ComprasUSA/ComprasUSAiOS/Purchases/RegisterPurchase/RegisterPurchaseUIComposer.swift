//
//  CreatePurchaseUIComposer.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation

public final class RegisterPurchaseUIComposer {
    private init() {}
    
    public static func composeCreatePurchase() -> RegisterPurchaseViewController {
        let vc = RegisterPurchaseViewController()
                
        let viewModel = RegisterPurchaseViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
