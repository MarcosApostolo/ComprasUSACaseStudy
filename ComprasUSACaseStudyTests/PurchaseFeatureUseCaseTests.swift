//
//  PurchaseFeatureUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 23/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class PurchaseFeatureUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.retrievalCompletions.count, 0)
        XCTAssertEqual(store.insertionCompletions.count, 0)
        XCTAssertEqual(store.deletionCompletions.count, 0)
        XCTAssertEqual(store.editionCompletions.count, 0)
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchaseFeatureUseCase, store: PurchaseStoreSpy) {
        let store = PurchaseStoreSpy()
        let sut = PurchaseFeatureUseCase(store: store)
        
        checkForMemoryLeaks(store)
        checkForMemoryLeaks(sut)
        
        return (sut, store)
    }
}

class PurchaseStoreSpy: PurchaseStore {
    var retrievalCompletions = [RetrievalCompletion]()
    var insertionCompletions = [InsertionCompletion]()
    var deletionCompletions = [DeletionCompletion]()
    var editionCompletions = [EditionCompletion]()
}

extension PurchaseStoreSpy {
    func retrievePurchases(completion: @escaping RetrievalCompletion) {
        
    }
    
    func insert(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping InsertionCompletion) {
        
    }
    
    func delete(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping DeletionCompletion) {
        
    }
    
    func edit(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping EditionCompletion) {
        
    }
}
