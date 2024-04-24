//
//  PurchaseFeatureUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 23/04/24.
//

import Foundation

public struct Purchase: Equatable {
    
}

public protocol PurchaseLoader {
    typealias LoadResult = Result<[Purchase], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}

public class PurchaseFeatureUseCase: PurchaseLoader {
    let store: PurchaseStore
    
    public enum Error: Swift.Error {
        case loadError
    }
    
    public init(store: PurchaseStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrievePurchases(completion: { result in
            completion(.failure(Error.loadError))
        })
    }
}
