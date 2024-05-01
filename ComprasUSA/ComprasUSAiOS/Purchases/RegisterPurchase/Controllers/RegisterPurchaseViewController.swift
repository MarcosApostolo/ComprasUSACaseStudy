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
    
    private(set) public var productNameTextFieldController = ProductNameTextFieldController()
    private(set) public lazy var valueTextField: TextFieldView = {
        let textField = TextFieldView()
        
        textField.placeholder = viewModel?.valueTextFieldPlaceholder
        
        return textField
    }()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(productNameTextFieldController.productNameTextField)
    }

    private func bind() {
        title = viewModel?.title
        
        productNameTextFieldController.productNameTextField.placeholder = viewModel?.productNameTextFieldPlaceholder
        productNameTextFieldController.errorLabel.text = viewModel?.productNameTFRequiredError
    }
}
