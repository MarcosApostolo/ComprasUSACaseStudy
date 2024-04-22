//
//  PurchaseStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 22/04/24.
//

import Foundation

public protocol PurchaseStore {
    typealias RetrievalResult = Result<[LocalPurchase], Error>
    typealias InsertionResult = Result<Void, Error>
    typealias DeletionResult = Result<Void, Error>
    typealias EditionResult = Result<LocalPurchase, Error>
    
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    typealias InsertionCompletion = (InsertionResult) -> Void
    typealias DeletionCompletion = (DeletionResult) -> Void
    typealias EditionCompletion = (EditionResult) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
    
    func insert(_ purchase: LocalPurchase, completion: @escaping InsertionCompletion)
    
    func delete(_ purchase: LocalPurchase, completion: @escaping DeletionCompletion)
    
    func edit(_ purchase: LocalPurchase, completion: @escaping EditionCompletion)
}
