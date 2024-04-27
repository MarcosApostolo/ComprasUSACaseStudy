//
//  PurchaseListViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import ComprasUSAiOS
import ComprasUSACaseStudy

final class PurchaseListViewControllerIntegrationTests: XCTestCase {
    func test_init_displayTitle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.title, localized("PURCHASES_TITLE"))
    }
    
    func test_loadPurchase_requestsPurchasesFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadMessages.count, 1)
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchasesListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PurchasesUIComposer.composePurchasesList(loader: loader)
        
        if !sut.isViewLoaded {
            sut.loadViewIfNeeded()
        }

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        checkForMemoryLeaks(sut)
        checkForMemoryLeaks(loader)
        
        return (sut, loader)
    }
}

class LoaderSpy: PurchaseLoader {
    var loadMessages = [(LoadResult) -> Void]()
    
    func load(completion: @escaping (LoadResult) -> Void) {
        loadMessages.append(completion)
    }
}
