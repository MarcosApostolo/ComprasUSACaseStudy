//
//  PurchasesListViewController+Helpers.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import ComprasUSAiOS
import UIKit

extension PurchasesListViewController {
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
    
    func simulateRetryLoad() {
        self.errorView.button.simulateTap()
    }
    
    func simulateRegisterPurchaseTap() {
        self.emptyMessageView.button.simulateTap()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: section)
    }
    
    private var section: Int {
        0
    }
    
    func purchaseCell(for index: Int) -> UITableViewCell? {
        return tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
}
