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
    
    func test_render_loadError() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeLoadWithError()
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "LOAD_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "LOAD_ERROR_DARK")
    }
    
    func test_render_purchases() {
        let (sut, loader) = makeSUT()
        
        let image0 = UIImage.make(withColor: .red).pngData()
        let image1 = UIImage.make(withColor: .blue).pngData()
        let image2 = UIImage.make(withColor: .green).pngData()
        let image3 = UIImage.make(withColor: .orange).pngData()
        
        let purchase0 = makePurchase(name: "a purchase", imageData: image0, value: 10)
        let purchase1 = makePurchase(name: "short", imageData: image1, value: 0.2)
        let purchase2 = makePurchase(name: "purchase with very very very very very very very long name", imageData: image2, value: 1)
        let purchase3 = makePurchase(name: "purchase with medium name size", imageData: image3, value: 1000)
        
        sut.simulateAppearance()
        
        loader.completeLoadSuccessfully(with: [purchase0, purchase1, purchase2, purchase3])
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "PURCHASES_LIST_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "PURCHASES_LIST_DARK")
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchasesListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PurchasesListUIComposer.composePurchasesList(
            loader: loader.loadPurchasesPublisher,
            onPurchaseRegister: {}
        )
        
        checkForMemoryLeaks(sut)
        checkForMemoryLeaks(loader)
        
        return (sut, loader)
    }
}
