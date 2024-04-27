//
//  PurchaseListSnapshotTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 27/04/24.
//

import XCTest
import ComprasUSAiOS

final class PurchaseListSnapshotTests: XCTestCase {
    func test_render_emptyPurchaseList() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeLoadSuccessfully(with: [])
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "EMPTY_PURCHASES_LIST_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "EMPTY_PURCHASES_LIST_DARK")
    }
    
    func test_render_loadingPurchases() {
        let (sut, _) = makeSUT()
        
        sut.simulateAppearance()
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "LOADING_PURCHASES_LIST_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "LOADING_PURCHASES_LIST_DARK")
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
