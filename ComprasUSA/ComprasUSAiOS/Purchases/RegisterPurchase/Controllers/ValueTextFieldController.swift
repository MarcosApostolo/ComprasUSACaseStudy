//
//  ValueTextFieldController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit

public class ValueTextFieldController: NSObject, UITextFieldDelegate {
    private(set) public lazy var valueTextField: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(didChangeTextFieldValue), for: .editingChanged)
                
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
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
    }
    
    @objc func didChangeTextFieldValue() {
        valueTextField.text = formatToCurrency(from: valueTextField.text)
    }
}

func formatToCurrency(from text: String?, locale: Locale = .init(identifier: "en-US")) -> String {
    guard let text = text, let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) else {
        return ""
    }
    
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currencyAccounting
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    let cleanText = regex.stringByReplacingMatches(
        in: text,
        options: NSRegularExpression.MatchingOptions(rawValue: 0),
        range: NSMakeRange(0, text.count),
        withTemplate: ""
    )
    
    let double = (cleanText as NSString).doubleValue
    
    let number = NSNumber(value: (double / 100))
    
    guard number != 0, let formattedNumber = formatter.string(from: number) else {
        return ""
    }
    
    return formattedNumber
}
