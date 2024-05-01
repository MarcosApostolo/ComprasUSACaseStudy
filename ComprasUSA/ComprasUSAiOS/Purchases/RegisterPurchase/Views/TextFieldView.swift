//
//  TextField.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit

public class TextFieldView: UIView {
    private(set) public lazy var textField: UITextField = {
        UITextField()
    }()
    
    private(set) public lazy var errorLabel: UILabel = {
        UILabel()
    }()
}

