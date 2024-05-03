//
//  CreatePurchaseUIComposer.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import Combine
import ComprasUSACaseStudy

public final class RegisterPurchaseUIComposer {
    private init() {}
    
    public static func composeCreatePurchase(
        loader: @escaping () -> StateLoader.Publisher
    ) -> RegisterPurchaseViewController {
        let vc = RegisterPurchaseViewController()
                
        let viewModel = RegisterPurchaseViewModel(loader: loader)
        
        vc.viewModel = viewModel
        
        return vc
    }
}
