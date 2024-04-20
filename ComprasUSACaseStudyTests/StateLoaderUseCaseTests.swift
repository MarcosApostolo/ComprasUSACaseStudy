//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest

protocol StateStore {
    func retrieve(completion: @escaping (Error) -> Void)
}

class StateLoaderUseCase {
    let store: StateStore
    
    public enum Error: Swift.Error {
        case loadError
    }
        
    init(store: StateStore) {
        self.store = store
    }
    
    func load(completion: @escaping (Error) -> Void) {
        store.retrieve { error in
            completion(.loadError)
        }
    }
}

final class StateLoaderUseCaseTests: XCTestCase {
    func test_init_doesNotSendMessagesToClient() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.retrievalCompletions.count, 0)
    }
    
    func test_load_sendLoadMessageToClient() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.retrievalCompletions.count, 1)
    }
    
    func test_load_storeCompletesWithLoadErrorOnError() {
        let (sut, store) = makeSUT()
        
        var receivedResult: StateLoaderUseCase.Error?
        
        sut.load { error in
            receivedResult = error
        }
        
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(receivedResult, .loadError)
    }

    // Helpers
    func makeSUT() -> (sut: StateLoaderUseCase, store: StoreSpy) {
        let store = StoreSpy()
        let sut = StateLoaderUseCase(store: store)
        
        checkForMemoryLeaks(store)
        checkForMemoryLeaks(sut)
        
        return (sut, store)
    }
    
    class StoreSpy: StateStore {
        var retrievalCompletions = [(Error) -> Void]()
        
        func retrieve(completion: @escaping (Error) -> Void) {
            retrievalCompletions.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](error)
        }
    }
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}
