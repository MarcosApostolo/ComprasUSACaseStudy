//
//  PurchaseLoaderSpy.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 03/05/24.
//

import Foundation
import ComprasUSACaseStudy

class PurchaseLoaderSpy: PurchaseLoader {
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
