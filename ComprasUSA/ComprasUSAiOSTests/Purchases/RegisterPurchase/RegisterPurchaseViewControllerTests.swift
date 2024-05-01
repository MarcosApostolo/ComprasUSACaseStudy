//
//  CreatePurchaseViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 01/05/24.
//

import XCTest
import ComprasUSAiOS

final class RegisterPurchaseViewControllerTests: XCTestCase {
    func test_init_display() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, localized("REGISTER_PURCHASE_TITLE"))
    }
    
    func test_init_hasProductNameTextFieldWithCorrectProperties() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.productNameTextFieldPlaceholder, localized("REGISTER_PURCHASE_PRODUCT_NAME_PLACEHOLDER_LABEL"))
        XCTAssertEqual(sut.productNameTextFieldValue, "")
    }
    
    func test_productNameTextField_whenEmptyAndTouched_displaysErrorMessage_andHidesAfterFocusedAgain() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.simulateAppearance()
        
        sut.simulateFocus(on: sut.productNameTextField)
        
        XCTAssertTrue(sut.productNameTextFieldIsFocused)
        
        sut.simulateUnfocus(on: sut.productNameTextFieldController.productNameTextField)

        XCTAssertFalse(sut.productNameTextFieldIsFocused)
        
        XCTAssertEqual(sut.productNameTextFieldValue, "")
        XCTAssertEqual(sut.productNameTextFieldErrorMessage, localized("REGISTER_PURCHASE_PRODUCT_NAME_REQUIRED_ERROR_LABEL"))
        XCTAssertTrue(sut.productNameTextFieldErrorMessageIsVisible)
        
        sut.simulateFocus(on: sut.productNameTextField)
        
        XCTAssertTrue(sut.productNameTextFieldIsFocused)
        XCTAssertFalse(sut.productNameTextFieldErrorMessageIsVisible)
    }
    
    func test_init_hasValueTextFieldWithCorrectProperties() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.valueTextFieldPlaceholder, localized("REGISTER_PURCHASE_VALUE_PLACEHOLDER_LABEL"))
        XCTAssertEqual(sut.valueTextFieldValue, "")
    }
    
    // MARK: Helpers
    func makeSUT() -> RegisterPurchaseViewController {
        let sut = RegisterPurchaseUIComposer.composeCreatePurchase()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func putInViewHierarchy(_ vc: UIViewController) {
        let window = UIWindow()
        
        window.addSubview(vc.view)
    }
}

private extension RegisterPurchaseViewController {
    var productNameTextField: UITextField {
        productNameTextFieldController.productNameTextField
    }
    
    var productNameErrorLabel: UILabel {
        productNameTextFieldController.errorLabel
    }
    
    var productNameTextFieldPlaceholder: String? {
        productNameTextField.placeholder
    }
    
    var productNameTextFieldValue: String? {
        productNameTextField.text
    }
    
    var valueTextFieldPlaceholder: String? {
        valueTextField.placeholder
    }
    
    var valueTextFieldValue: String? {
        valueTextField.text
    }
    
    var productNameTextFieldIsFocused: Bool {
        productNameTextField.isFirstResponder
    }
    
    var productNameTextFieldErrorMessage: String? {
        productNameErrorLabel.text
    }
    
    var productNameTextFieldErrorMessageIsVisible: Bool {
        !productNameErrorLabel.isHidden
    }
    
    func simulateFocus(on textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func simulateUnfocus(on textField: UITextField) {
        textField.resignFirstResponder()
    }
}
