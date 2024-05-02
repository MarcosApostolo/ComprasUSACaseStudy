//
//  CreatePurchaseViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 01/05/24.
//

import XCTest
import ComprasUSAiOS
import ComprasUSACaseStudy

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
    
    func test_valueTextField_whenReceivingInvalidInput_doesNotUpdateValue() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        assertThat(sut, hasValueTextFieldValue: "", whenValueTyped: "a")
        assertThat(sut, hasValueTextFieldValue: "", whenValueTyped: "?")
        assertThat(sut, hasValueTextFieldValue: "", whenValueTyped: "-")
    }
    
    func test_paymentTypesPicker_hasAllPaymentMethods() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.paymentTypePickerNumberOfRows, 2)
    }
    
    func test_paymentTypesPicker_whenPickingType_updatesPickerLocalState() {
        let sut = makeSUT()
        
        let cardPaymentTypeRowNumber = 0
        
        sut.simulateAppearance()
        
        sut.selectPaymentType(cardPaymentTypeRowNumber)
        
        XCTAssertEqual(sut.pickerSelectedOption, .card)
    }
    
    func test_paymentTypesPicker_whenTappingTypeLabel_opensPicker() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        putInViewHierarchy(sut)
        
        XCTAssertFalse(sut.pickerViewIsOpen)
        
        sut.paymentTypeButton.simulateTap()
        
        XCTAssertTrue(sut.pickerViewIsOpen)
        
        sut.tapPaymentDoneButton()
        
        XCTAssertFalse(sut.pickerViewIsOpen)
    }
    
    func test_statesPicker_hasAllStates() {
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.statesPickerNumberOfRows, 52)
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
        
        XCTAssertEqual(sut.valueTextFieldValue, value, file: file, line: line)
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
    
    func selectPaymentType(_ row: Int) {
        paymentTypesPickerController.pickerView.delegate?.pickerView?(paymentTypesPickerController.pickerView, didSelectRow: row, inComponent: 0)
    }
    
    var paymentTypePickerNumberOfRows: Int {
        paymentTypesPickerController.pickerView.numberOfRows(inComponent: paymentTypePickerComponentIndex)
    }
    
    var pickerSelectedOption: PaymentType? {
        paymentTypesPickerController.selectedOption
    }
    
    var statesPickerNumberOfRows: Int {
        statesPickerController.pickerView.numberOfRows(inComponent: statesPickerComponentIndex)
    }
    
    var paymentTypePickerComponentIndex: Int {
        0
    }
    
    var statesPickerComponentIndex: Int {
        0
    }
    
    var paymentTypeButton: UIButton {
        paymentTypesPickerController.typeButton
    }
    
    var pickerViewIsOpen: Bool {
        paymentTypesPickerController.textField.isFirstResponder
    }
    
    func tapPaymentDoneButton() {
        paymentTypesPickerController.didTapDoneButton()
    }
}
