//
//  UIButton+TestHelpers.swift
//  ComprasUSACaseStudyAppTests
//
//  Created by Marcos Amaral on 03/05/24.
//

import Foundation
import UIKit

extension UIButton {
    func simulateTap() {
        sendActions(for: .touchUpInside)
    }
}

extension UITextField {
    func simulateType() {
        sendActions(for: .editingChanged)
    }
}
