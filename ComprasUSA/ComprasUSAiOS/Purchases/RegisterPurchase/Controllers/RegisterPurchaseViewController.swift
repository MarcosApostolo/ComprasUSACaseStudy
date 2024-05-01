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
    
    private(set) public lazy var productNameTextField: TextFieldView = {
        let textField = TextFieldView()
        
        textField.textField.placeholder = viewModel?.productNameTFPlaceholder
        
        return textField
    }()
    
    private(set) public lazy var valueTextField: TextFieldView = {
        let textField = TextFieldView()
        
        textField.textField.placeholder = viewModel?.valueTFPlaceholder
        
        return textField
    }()
    
    private func bind() {
        title = viewModel?.title
    }
}
