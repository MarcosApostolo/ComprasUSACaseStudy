//
//  UIPurchaseDetailComposer.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public class PurchaseDetailsUIComposer {
    private init() {}
    
    public static func composePurchaseDetails(_ purchase: Purchase) -> PurchaseDetailsViewController {
        let vc = PurchaseDetailsViewController()
        let viewModel = PurchaseDetailsViewModel(model: purchase, imageTransformer: UIImage.init)
        
        vc.viewModel = viewModel
        
        return vc
    }
}
