//
//  ProductNameTextFieldController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit

public class ProductNameTextFieldController: NSObject, UITextFieldDelegate {
    private(set) public lazy var productNameTextField: TextFieldView = {
        let textField = TextFieldView()
        
        textField.delegate = self
                
        return textField
    }()
    
    private(set) public lazy var errorLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        
        return label
    }()
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            errorLabel.isHidden = false
            return
        }
    }
}
