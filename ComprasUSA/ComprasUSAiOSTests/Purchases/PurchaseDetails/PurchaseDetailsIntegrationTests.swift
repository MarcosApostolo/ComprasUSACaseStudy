//
//  PurchaseDetailsIntegrationTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 28/04/24.
//

import XCTest
import ComprasUSACaseStudy
import ComprasUSAiOS

final class PurchaseDetailsIntegrationTests: XCTestCase {
    func test_init_displayProductNameOnTitle() {
        let purchase = makePurchase(state: nil)
        
        let sut = makeSUT(with: purchase)
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, purchase.name)
    }
    
    func test_stateInfo_displayErrorMessageWhenStateInfoIsMissing() {
        let purchase = makePurchase(state: nil)
        
        let sut = makeSUT(with: purchase)
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.isShowingStateInfoError, true, "Expected State Info Error to be displayed when state info is missing")
    }

    // MARK: Helpers
    func makeSUT(with purchase: Purchase) -> PurchaseDetailsViewController {
        let sut = PurchaseDetailsUIComposer
            .composePurchaseDetails(purchase)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}

private extension PurchaseDetailsViewController {
    var isShowingStateInfoError: Bool? {
        !footerView.stateInfoErrorLabel.isHidden
    }
}
