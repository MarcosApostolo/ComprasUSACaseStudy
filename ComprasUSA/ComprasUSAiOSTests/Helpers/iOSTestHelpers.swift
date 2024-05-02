//
//  TestHelpers.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

private extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

extension UITextField {
    func simulateType() {
        simulate(event: .editingChanged)
    }
}

