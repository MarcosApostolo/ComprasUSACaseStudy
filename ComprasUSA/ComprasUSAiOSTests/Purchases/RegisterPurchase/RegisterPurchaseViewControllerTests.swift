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
        
        sut.simulateUnfocus(on: sut.productNameTextField)

        XCTAssertFalse(sut.productNameTextFieldIsFocused)
        
        XCTAssertEqual(sut.productNameTextFieldValue, "")
        XCTAssertEqual(sut.productNameTextFieldErrorMessage, localized("REGISTER_PURCHASE_GENERIC_REQUIRED_ERROR_LABEL"))
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
    
    func test_valueTextField_whenEmptyAndTouched_displaysErrorMessage_andHidesAfterFocusedAgain() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.simulateAppearance()
        
        sut.simulateFocus(on: sut.valueTextField)
        
        XCTAssertTrue(sut.valueTextFieldIsFocused)
        
        sut.simulateUnfocus(on: sut.valueTextField)
        
        XCTAssertFalse(sut.valueTextFieldIsFocused)
        
        XCTAssertEqual(sut.valueTextFieldValue, "")
        XCTAssertEqual(sut.valueTextFieldErrorMessage, localized("REGISTER_PURCHASE_GENERIC_REQUIRED_ERROR_LABEL"))
        XCTAssertTrue(sut.valueTextFieldErrorMessageIsVisible)
        
        sut.simulateFocus(on: sut.valueTextField)
        
        XCTAssertTrue(sut.valueTextFieldIsFocused)
        XCTAssertFalse(sut.valueTextFieldErrorMessageIsVisible)
    }
    
    func test_valueTextField_hasCorrectProperties() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.valueTextFieldKeyboardType, .decimalPad)
    }
    
    func test_valueTextField_applyCurrencyFormattingToValue() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        assertThat(sut, hasValueTextFieldValue: "$0.01", whenValueTyped: "1")
        assertThat(sut, hasValueTextFieldValue: "$0.12", whenValueTyped: "12")
        assertThat(sut, hasValueTextFieldValue: "$1.23", whenValueTyped: "123")
        assertThat(sut, hasValueTextFieldValue: "$12.34", whenValueTyped: "1234")
        assertThat(sut, hasValueTextFieldValue: "$0.12", whenValueTyped: "12")
        assertThat(sut, hasValueTextFieldValue: "$0.01", whenValueTyped: "1")
    }
    
    // MARK: Helpers
    func makeSUT() -> RegisterPurchaseViewController {
        let sut = RegisterPurchaseUIComposer.composeCreatePurchase()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func assertThat(_ sut: RegisterPurchaseViewController, hasValueTextFieldValue value: String, whenValueTyped typed: String, file: StaticString = #file, line: UInt = #line) {
        sut.valueTextField.text = typed
        sut.valueTextField.simulateType()
        
        XCTAssertEqual(sut.valueTextFieldValue, value)
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
    
    var valueTextField: UITextField {
        valueTextFieldController.valueTextField
    }
    
    var valueErrorLabel: UILabel {
        valueTextFieldController.errorLabel
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
    
    var valueTextFieldIsFocused: Bool {
        valueTextField.isFirstResponder
    }
    
    var valueTextFieldErrorMessage: String? {
        valueErrorLabel.text
    }
    
    var valueTextFieldErrorMessageIsVisible: Bool {
        !valueErrorLabel.isHidden
    }
    
    var valueTextFieldKeyboardType: UIKeyboardType {
        valueTextField.keyboardType
    }
}
