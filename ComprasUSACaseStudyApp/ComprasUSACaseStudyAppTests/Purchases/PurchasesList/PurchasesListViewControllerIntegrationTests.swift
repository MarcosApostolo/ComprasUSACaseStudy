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

final class PurchaseListUIIntegrationTests: XCTestCase {
    func test_init_displayTitle() {
        let (sut, _, _) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, localized("PURCHASES_TITLE"))
    }
    
    func test_loadPurchase_requestsPurchasesFromLoader() {
        let (sut, loader, _) = makeSUT()
        
        XCTAssertEqual(loader.loadMessages.count, 0)
        
        sut.simulateAppearance()
        
        XCTAssertEqual(loader.loadMessages.count, 1)
    }
    
    func test_loadPurchase_displayLoadingIndicatorWhileLoadingPurchases() {
        let (sut, loader, _) = makeSUT()
                
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading before view load")
        
        sut.simulateAppearance()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading after view load")
        
        loader.completeLoadSuccessfully()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading after load finishes")
    }
    
    func test_loadPurchase_displayErrorMessageOnLoadPurchasesError() {
        let (sut, loader, _) = makeSUT()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message before view load")
        
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message before load finishes")
        
        loader.completeLoadWithError()
        
        XCTAssertTrue(sut.isShowingErrorMessage, "Expected error message after load finishes with error")
        XCTAssertEqual(sut.loadErrorMessage, localized("PURCHASES_LOAD_ERROR"))
        
        sut.simulateRetryLoad()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message after user initiates a new load")
        XCTAssertNil(sut.loadErrorMessage)
        
        loader.completeLoadSuccessfully()
        
        XCTAssertFalse(sut.isShowingErrorMessage, "Expected no error message after load finishes with success")
        XCTAssertNil(sut.loadErrorMessage)
    }
    
    func test_loadPurchase_displayEmptyPurchasesMessageWhenLoadIsCompletesWithEmptyList() {
        let (sut, loader, _) = makeSUT()
                
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message before view load")
        
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingEmptyMessage, "Expected no empty message before load finishes")
        
        loader.completeLoadSuccessfully(with: [])
        
        XCTAssertTrue(sut.isShowingEmptyMessage, "Expected empty message after load finishes with empty purchases")
        XCTAssertEqual(sut.emptyPurchasesMessage, localized("PURCHASES_EMPTY_LOAD_MESSAGE"))
    }
    
    func test_loadPurchase_displayPurchasesWhenLoadIsSuccessfull() {
        let (sut, loader, _) = makeSUT()
        
        let purchase0 = makePurchase()
        let purchase1 = makePurchase()
        let purchase2 = makePurchase()
        let purchase3 = makePurchase()
        
        assertThat(sut, isRendering: [])
        
        sut.simulateAppearance()
        
        loader.completeLoadSuccessfully(with: [purchase0, purchase1, purchase2, purchase3])
        
        assertThat(sut, isRendering: [purchase0, purchase1, purchase2, purchase3])
    }
    
    func test_onPurchaseRegister_sendsRegisterPurchaseMessage() {
        let (sut, loader, navigationSpy) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(navigationSpy.numberOfRegisterCalls, 0)
        
        loader.completeLoadSuccessfully(with: [])
        
        XCTAssertTrue(sut.isShowingEmptyMessage, "Expected empty message after load finishes with empty purchases")
        XCTAssertEqual(sut.emptyPurchasesMessage, localized("PURCHASES_EMPTY_LOAD_MESSAGE"))
        
        sut.simulateRegisterPurchaseTap()
        
        XCTAssertEqual(navigationSpy.numberOfRegisterCalls, 1)
    }
    
    func test_loadPurchase_dispatchesFromBackgroundToMainThread() {
        let (sut, loader, _) = makeSUT()
        
        sut.simulateAppearance()

        let exp = expectation(description: "Wait for background queue")
        
        DispatchQueue.global().async {
            loader.completeLoadSuccessfully()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchasesListViewController, loader: PurchaseLoaderSpy, navigationSpy: NavigationSpy) {
        let navigationSpy = NavigationSpy()
        let loader = PurchaseLoaderSpy()
        let sut = PurchasesListUIComposer.composePurchasesList(
            loader: loader.loadPurchasesPublisher,
            onPurchaseRegister: navigationSpy.onPurchaseRegister
        )
        
        checkForMemoryLeaks(sut)
        checkForMemoryLeaks(loader)
        checkForMemoryLeaks(navigationSpy)
        
        return (sut, loader, navigationSpy)
    }
    
    func assertThat(_ sut: PurchasesListViewController, isRendering purchases: [Purchase], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedPurchaseCellViews(), purchases.count, "Expected one cell for each purchase loaded")
        
        purchases.enumerated().forEach({ index, purchase in
            let view = sut.purchaseCell(for: index)

            guard let _ = view as? PurchaseCell else {
                return XCTFail("Expected \(PurchaseCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
            }
        })
    }
    
    class NavigationSpy {
        var numberOfRegisterCalls = 0
        
        public func onPurchaseRegister() {
            numberOfRegisterCalls += 1
        }
    }
}
