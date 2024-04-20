//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

class CoreDataStateStore: StateStore {
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success([]))
    }
}

final class StateStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyStates() {
        let sut = CoreDataStateStore()
                
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { receivedResult in
            switch receivedResult {
            case let .success(states):
                XCTAssertEqual(states, [])
            case let .failure(error):
                XCTFail("Expected success but got \(error) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffect_afterReturningEmpty() {
        let sut = CoreDataStateStore()
                
        let exp = expectation(description: "Wait for cache retrieval")
        let exp2 = expectation(description: "Wai for second retrieval")
        
        sut.retrieve { receivedResult in
            switch receivedResult {
            case let .success(states):
                XCTAssertEqual(states, [])
            case let .failure(error):
                XCTFail("Expected success but got \(error) instead")
            }
            
            exp.fulfill()
        }
        
        sut.retrieve { receivedResult in
            switch receivedResult {
            case let .success(states):
                XCTAssertEqual(states, [])
            case let .failure(error):
                XCTFail("Expected success but got \(error) instead")
            }
            
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1.0)
    }
    
    // Helpers
    func makeSUT() -> CoreDataStateStore {
        let sut = CoreDataStateStore()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
}
