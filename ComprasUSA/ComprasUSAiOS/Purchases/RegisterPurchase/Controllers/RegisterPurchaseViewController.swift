//
//  CreatePurchase.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit

public class RegisterPurchaseViewController: UIViewController {
    var viewModel: RegisterPurchaseViewModel? {
        didSet { bind() }
    }
    
    private func bind() {
        title = viewModel?.title
    }
}
