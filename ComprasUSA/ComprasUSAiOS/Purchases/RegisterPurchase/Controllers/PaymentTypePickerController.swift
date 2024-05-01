//
//  PaymentMethodPickerController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public protocol PaymentTypePickerDelegate {
    func didSelectPaymentType(_ paymentType: PaymentType)
}

public final class PaymentTypePickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public let paymentTypes: [PaymentType]
    
    public init(paymentTypes: [PaymentType]) {
        self.paymentTypes = paymentTypes
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        paymentTypes.count
    }
}
