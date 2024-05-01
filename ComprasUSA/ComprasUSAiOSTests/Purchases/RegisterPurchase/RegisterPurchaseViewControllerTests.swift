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
        
        XCTAssertEqual(sut.title, localized("REGISTER_PURCHASE_TITLE"))
    }
    
    func test_init_hasProductNameTextFieldWithCorrectProperties() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.productNameTextFieldPlaceholder, localized("REGISTER_PURCHASE_PRODUCT_NAME_PLACEHOLDER_LABEL"))
        XCTAssertEqual(sut.productNameTextFieldValue, "")
    }
    
    // MARK: Helpers
    func makeSUT() -> RegisterPurchaseViewController {
        let sut = RegisterPurchaseUIComposer.composeCreatePurchase()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}

private extension RegisterPurchaseViewController {
    var productNameTextFieldPlaceholder: String? {
        productNameTextField.placeholder
    }
    
    var productNameTextFieldValue: String? {
        productNameTextField.text
    }
}
