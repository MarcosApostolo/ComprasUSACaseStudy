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
        let purchase = makePurchase()
        
        let sut = makeSUT(with: purchase)
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .medium)), named: "PURCHASE_DETAILS_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark, contentSize: .medium)), named: "PURCHASE_DETAILS_DARK")
    }

    // MARK: Helpers
    func makeSUT(with purchase: Purchase) -> PurchaseDetailsViewController {
        let sut = PurchaseDetailsViewController(purchase: purchase)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}
