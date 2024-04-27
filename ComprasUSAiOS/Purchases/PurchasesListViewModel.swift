//
//  PurchasesListViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation
import Combine
import ComprasUSACaseStudy

class PurchasesListViewModel {
    private let loader: () -> PurchaseLoader.Publisher
    private var cancellable: Cancellable?
    
    typealias Observer<T> = (T) -> Void
    
    var onLoadingStateChange: Observer<Bool>?
    
    var title: String {
        return NSLocalizedString("PURCHASES_TITLE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Title for the purchases view")
    }
    
    init(loader: @escaping () -> PurchaseLoader.Publisher) {
        self.loader = loader
    }
    
    func loadPurchases() {
        onLoadingStateChange?(true)
        
        self.cancellable = loader().sink(
            receiveCompletion: { [weak self] _ in
                self?.onLoadingStateChange?(false)
            },
            receiveValue: { _ in }
        )
    }
}
