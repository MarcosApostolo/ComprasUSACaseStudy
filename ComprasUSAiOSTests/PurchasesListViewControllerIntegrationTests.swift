//
//  PurchaseListViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import Combine
import ComprasUSAiOS
import ComprasUSACaseStudy

final class PurchaseListViewControllerIntegrationTests: XCTestCase {
    func test_init_displayTitle() {
        let (sut, _) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, localized("PURCHASES_TITLE"))
    }
    
    func test_loadPurchase_requestsPurchasesFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadMessages.count, 0)
        
        sut.simulateAppearance()
        
        XCTAssertEqual(loader.loadMessages.count, 1)
    }
    
    func test_loadPurchase_displayLoadingIndicatorWhileLoadingPurchases() {
        let (sut, loader) = makeSUT()
                
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading before view load")
        
        sut.simulateAppearance()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading after view load")
        
        loader.completeLoadSuccessfully()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading after load finishes")
    }
    
    func test_loadPurchase_displayErrorMessageOnLoadPurchasesError() {
        let (sut, loader) = makeSUT()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message before view load")
        
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message before load finishes")
        
        loader.completeLoadWithError()
        
        XCTAssertTrue(sut.isShowingErrorMessage, "Expected error message after load finishes with error")
        XCTAssertEqual(sut.loadErrorMessage, localized("PURCHASES_LOAD_ERROR"))
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchasesListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PurchasesUIComposer.composePurchasesList(loader: loader.loadPurchasesPublisher)
        
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
    
    func completeLoadSuccessfully(with purchases: [Purchase] = [makePurchase()], at index: Int = 0) {
        loadMessages[index](.success(purchases))
    }
    
    func completeLoadWithError(error: Error = anyNSError(), at index: Int = 0) {
        loadMessages[index](.failure(error))
    }
}

private extension PurchasesListViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    var isShowingLoadingIndicator: Bool {
        self.loadingIndicator.isAnimating == true
    }
    
    var isShowingErrorMessage: Bool {
        self.errorView.isHidden == false
    }
    
    var loadErrorMessage: String? {
        self.errorMessage
    }
}
