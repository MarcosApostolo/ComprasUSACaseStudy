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
    
    private(set) public lazy var productNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = viewModel?.productNameTFPlaceholder
        
        return textField
    }()
    
    private(set) public lazy var valueTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = viewModel?.valueTFPlaceholder
        
        return textField
    }()
    
    private func bind() {
        title = viewModel?.title
    }
}
