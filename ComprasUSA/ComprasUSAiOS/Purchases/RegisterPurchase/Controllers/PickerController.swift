//
//  PickerController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 02/05/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public final class PickerController<Option>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public let options: [Option]
    
    public var selectedOption: Option?
    
    private(set) public lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    private(set) public lazy var textField = UITextView(frame: .zero)
    
    private(set) public lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        
        doneButton.isEnabled = false

        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }()
    
    private(set) public lazy var typeButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(didTapTypeButton), for: .touchUpInside)
        
        return button
    }()
    
    public init(options: [Option]) {
        self.options = options
        
        super.init()
        
        setup()
    }
    
    func setup() {
        textField.inputView = pickerView
        textField.inputAccessoryView = doneToolbar
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = options[row]
    }
    
    @objc private func didTapTypeButton() {
        textField.becomeFirstResponder()
    }
    
    @objc public func didTapDoneButton() {
        textField.resignFirstResponder()
    }
}
