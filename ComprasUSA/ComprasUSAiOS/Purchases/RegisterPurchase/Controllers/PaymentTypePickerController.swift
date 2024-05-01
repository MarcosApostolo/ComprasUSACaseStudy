//
//  PaymentMethodPickerController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public final class PaymentTypePickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public let paymentTypes: [PaymentType]
    
    public var selectedType: PaymentType?
    
    private(set) public lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    public init(paymentTypes: [PaymentType]) {
        self.paymentTypes = paymentTypes
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        paymentTypes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = paymentTypes[row]
    }
}
