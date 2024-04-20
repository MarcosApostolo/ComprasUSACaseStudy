//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

class CoreDataStateStore: StateStore {
    enum StoreError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public typealias Result = StateStore.RetrievalResult
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success([]))
    }
}

final class CoreDataStateStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyStates() {
        let sut = CoreDataStateStore()
        
        expect(sut, toCompleteWith: .success([]), when: {})
    }
    
    func test_retrieve_hasNoSideEffect_afterReturningEmpty() {
        let sut = CoreDataStateStore()
        
        expect(sut, toCompleteWith: .success([]), when: {})
        expect(sut, toCompleteWith: .success([]), when: {})
    }
    
    // Helpers
    func makeSUT() -> CoreDataStateStore {
        let sut = CoreDataStateStore()
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func expect(_ sut: CoreDataStateStore, toCompleteWith expectedResult: CoreDataStateStore.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedStates), .success(expectedStates)) :
                XCTAssertEqual(receivedStates, expectedStates, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
