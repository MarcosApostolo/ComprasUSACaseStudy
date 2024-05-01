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
    
    // MARK: Helpers
    func makeSUT() -> RegisterPurchaseViewController {
        let sut = RegisterPurchaseUIComposer.composeCreatePurchase()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}
