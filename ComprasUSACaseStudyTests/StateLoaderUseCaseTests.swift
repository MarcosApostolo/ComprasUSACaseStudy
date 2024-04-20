//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest

protocol StateStore {
    func retrieve(completion: (Error) -> Void)
}

class StateLoaderUseCase {
    let store: StateStore
    
    public enum Error: Swift.Error {
        case generic
    }
        
    init(store: StateStore) {
        self.store = store
    }
    
    func load(completion: @escaping (Error) -> Void) {
        store.retrieve { error in
            completion(.generic)
        }
    }
}

final class StateLoaderUseCaseTests: XCTestCase {
    func test_init_doesNotSendMessagesToClient() {
        let store = StoreSpy()
        _ = StateLoaderUseCase(store: store)
        
        XCTAssertEqual(store.loadMessages, 0)
    }
    
    func test_load_sendLoadMessageToClient() {
        let store = StoreSpy()
        let sut = StateLoaderUseCase(store: store)
        
        sut.load { _ in }
        
        XCTAssertEqual(store.loadMessages, 1)
    }
    
    func test_load_storeCompletesWithLoadErrorOnError() {
        let store = StoreSpy()
        let sut = StateLoaderUseCase(store: store)
        
        var receivedResult: StateLoaderUseCase.Error?
        
        sut.load { error in
            receivedResult = error
        }
        
        XCTAssertEqual(receivedResult, .generic)
    }

    // Helpers
    class StoreSpy: StateStore {
        
        var loadMessages = 0
        
        func retrieve(completion: (Error) -> Void) {
            loadMessages += 1
            
            completion(anyNSError())
        }
    }
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}
