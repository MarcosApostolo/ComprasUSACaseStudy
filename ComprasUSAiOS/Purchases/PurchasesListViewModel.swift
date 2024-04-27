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
    var onErrorStateChange: Observer<String?>?
    
    var title: String {
        return NSLocalizedString("PURCHASES_TITLE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Title for the purchases view")
    }
    
    var errorMessage: String {
        return NSLocalizedString("PURCHASES_LOAD_ERROR",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Error message for when the load purchases completes with error")
    }
    
    init(loader: @escaping () -> PurchaseLoader.Publisher) {
        self.loader = loader
    }
    
    func loadPurchases() {
        onLoadingStateChange?(true)
        
        self.cancellable = loader().sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.onErrorStateChange?(self?.errorMessage)
                default:
                    break
                }
                self?.onLoadingStateChange?(false)
            },
            receiveValue: { _ in }
        )
    }
}
