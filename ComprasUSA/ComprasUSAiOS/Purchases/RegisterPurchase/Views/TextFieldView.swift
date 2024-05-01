//
//  TextField.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit

public class TextFieldView: UITextField {    
    private(set) public lazy var errorLabel: UILabel = {
        UILabel()
    }()
}

