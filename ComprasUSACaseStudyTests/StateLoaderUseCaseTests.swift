//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest

protocol StateStore {
    func retrieve()
}

class StateLoaderUseCase {
    let store: StateStore
    
    init(store: StateStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
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
        
        sut.load()
        
        XCTAssertEqual(store.loadMessages, 1)
    }

    // Helpers
    class StoreSpy: StateStore {
        var loadMessages = 0
        
        func retrieve() {
            loadMessages += 1
        }
    }
}
