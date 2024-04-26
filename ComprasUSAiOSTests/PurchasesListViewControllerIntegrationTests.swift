//
//  PurchaseListViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import ComprasUSAiOS

final class PurchaseListViewControllerIntegrationTests: XCTestCase {
    func test_init_displayTitle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.title, localized("PURCHASES_TITLE"))
    }
    
    // MARK: Helpers
    func makeSUT() -> PurchasesListViewController {
        let sut = PurchasesListViewController()
        
        if !sut.isViewLoaded {
            sut.loadViewIfNeeded()
        }

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}

