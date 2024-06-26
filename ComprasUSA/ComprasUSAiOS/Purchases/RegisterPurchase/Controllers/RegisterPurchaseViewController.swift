//
//  CreatePurchase.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public class RegisterPurchaseViewController: UIViewController {
    var viewModel: RegisterPurchaseViewModel? {
        didSet { bind() }
    }
    
    private(set) public var productNameTextFieldController = ProductNameTextFieldController()
    private(set) public var valueTextFieldController = ValueTextFieldController()
    private(set) public var paymentTypesPickerController = PickerController<PaymentType>(options: PaymentType.allCases)
    private(set) public var statesPickerController = PickerController<USAStates>(options: USAStates.allCases)

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(productNameTextFieldController.productNameTextField)
        view.addSubview(valueTextFieldController.valueTextField)
        view.addSubview(paymentTypesPickerController.typeButton)
        view.addSubview(paymentTypesPickerController.pickerView)
        view.addSubview(paymentTypesPickerController.textField)
        
        statesPickerController.onOptionSelect = { [weak self] _ in
            self?.viewModel?.loadStates()
        }
    }

    private func bind() {
        title = viewModel?.title
        
        productNameTextFieldController.productNameTextField.placeholder = viewModel?.productNameTextFieldPlaceholder
        productNameTextFieldController.errorLabel.text = viewModel?.genericRequiredError
        
        valueTextFieldController.valueTextField.placeholder = viewModel?.valueTextFieldPlaceholder
        valueTextFieldController.errorLabel.text = viewModel?.genericRequiredError
    }
}
