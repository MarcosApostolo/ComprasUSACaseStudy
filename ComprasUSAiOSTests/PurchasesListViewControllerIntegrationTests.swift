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
        
        sut.simulateUserInitiatedLoad()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message after user initiates a new load")
        XCTAssertNil(sut.loadErrorMessage)
        
        loader.completeLoadSuccessfully()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message after load finishes with success")
        XCTAssertNil(sut.loadErrorMessage)
    }
    
    func test_loadPurchase_displayEmptyPurchasesMessageWhenLoadIsCompletesWithEmptyList() {
        let (sut, loader) = makeSUT()
        
        let purchase = makePurchase()
        
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message before view load")
        
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message before load finishes")
        
        loader.completeLoadSuccessfully(with: [])
        
        XCTAssertTrue(sut.isShowingEmptyMessage, "Expected empty message after load finishes with empty purchases")
        XCTAssertEqual(sut.emptyPurchasesMessage, localized("PURCHASES_EMPTY_LOAD_MESSAGE"))
        
        sut.simulateUserInitiatedLoad()
        
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message after load finishes with purchases")
        
        loader.completeLoadSuccessfully(with: [purchase])
        
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message after load finishes with purchases")
    }
    
    func test_loadPurchase_displayPurchasesWhenLoadIsSuccessfull() {
        let (sut, loader) = makeSUT()
        
        let purchase0 = makePurchase()
        let purchase1 = makePurchase()
        let purchase2 = makePurchase()
        let purchase3 = makePurchase()
        
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 0, "Expected no purchases to be displayed before view loads")
        
        sut.simulateAppearance()
        
        loader.completeLoadSuccessfully(with: [purchase0, purchase1, purchase2, purchase3])
        
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 4, "Expected one cell for each purchase loaded")
    }
    
    func test_loadPurchase_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()

        let exp = expectation(description: "Wait for background queue")
        
        DispatchQueue.global().async {
            loader.completeLoadSuccessfully()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
    
    var isShowingEmptyMessage: Bool {
        self.emptyMessageView.isHidden == false
    }
    
    var loadErrorMessage: String? {
        self.errorMessage
    }
    
    var emptyPurchasesMessage: String? {
        self.emptyMessage
    }
    
    func simulateUserInitiatedLoad() {
        self.retryButton.simulateTap()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: section)
    }
    
    private var section: Int {
        0
    }
}
