//
//  PurchaseDetailsSnapshotTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 28/04/24.
//

import XCTest
import ComprasUSAiOS
import ComprasUSACaseStudy

final class PurchaseDetailsSnapshotTests: XCTestCase {
    func test_render_purchaseDetails() {
        let image = UIImage.make(withColor: .lightGray).pngData()
        
        let purchase = makePurchase(name: "A Purchase", imageData: image)
        
        let sut = makeSUT(with: purchase)
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "PURCHASE_DETAILS_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "PURCHASE_DETAILS_DARK")
    }
    
    func test_render_purchaseDetails_withoutStateInfo() {
        let image = UIImage.make(withColor: .lightGray).pngData()
        
        let purchase = makePurchase(name: "A Purchase", imageData: image, state: nil)
        
        let sut = makeSUT(with: purchase)
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "PURCHASE_DETAILS_WITHOUT_STATE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "PURCHASE_DETAILS_WITHOUT_STATE_DARK")
    }

    // MARK: Helpers
    func makeSUT(with purchase: Purchase) -> PurchaseDetailsViewController {
        let sut = PurchaseDetailsUIComposer
            .composePurchaseDetails(purchase)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}
