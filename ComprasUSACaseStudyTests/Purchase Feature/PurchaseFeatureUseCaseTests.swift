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
    
    // MARK: Load Tests
    func test_load_sendsLoadMessageToStore() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.retrievalCompletions.count, 1)
    }
    
    func test_load_completesWithErrorOnStoreError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteLoadWith: .failure(PurchaseFeatureUseCase.Error.loadError), when: {
            store.completeRetrieval(with: anyNSError())
        })
    }
    
    func test_load_completesWithPurchasesWhenStoreCompletesSuccessufully() {
        let (sut, store) = makeSUT()
        
        let purchase = makePurchaseObjects()
        
        expect(sut, toCompleteLoadWith: .success([purchase.model]), when: {
            store.completeRetrievalSuccessfully([purchase.local])
        })
    }
    
    func test_load_completesWithPurchasesWithNoStatesWhenStoreCompletesSuccessufully() {
        let (sut, store) = makeSUT()
        
        let purchase = makePurchaseObjects(state: nil)
        
        expect(sut, toCompleteLoadWith: .success([purchase.model]), when: {
            store.completeRetrievalSuccessfully([purchase.local])
        })
    }
    
    // MARK: Helpers
    func makeSUT() -> (sut: PurchaseFeatureUseCase, store: PurchaseStoreSpy) {
        let store = PurchaseStoreSpy()
        let sut = PurchaseFeatureUseCase(store: store)
        
        checkForMemoryLeaks(store)
        checkForMemoryLeaks(sut)
        
        return (sut, store)
    }
    
    func expect(_ sut: PurchaseFeatureUseCase, toCompleteLoadWith expectedResult: PurchaseFeatureUseCase.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for action to finish")
        
        sut.load { receivedResult in
            switch(expectedResult, receivedResult) {
            case let (.success(expecedItems), .success(receivedItems)):
                XCTAssertEqual(expecedItems, receivedItems, file: file, line: line)
            case let (.failure(expectedError as PurchaseFeatureUseCase.Error), .failure(receivedError as PurchaseFeatureUseCase.Error)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
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
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalSuccessfully(_ purchase: [LocalPurchase], at index: Int = 0) {
        retrievalCompletions[index](.success(purchase))
    }
}

extension PurchaseStoreSpy {
    func insert(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping InsertionCompletion) {
        
    }
    
    func delete(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping DeletionCompletion) {
        
    }
    
    func edit(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping EditionCompletion) {
        
    }
}