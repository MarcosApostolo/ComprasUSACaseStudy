//
//  PurchaseListViewControllerTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import UIKit

class PurchaseListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Purchases"
    }
}

final class PurchaseListViewControllerIntegrationTests: XCTestCase {
    func test_init_displayTitle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.title, "Purchases")
    }
    
    // MARK: Helpers
    func makeSUT() -> PurchaseListViewController {
        let sut = PurchaseListViewController()
        
        if !sut.isViewLoaded {
            sut.loadViewIfNeeded()
        }

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}
