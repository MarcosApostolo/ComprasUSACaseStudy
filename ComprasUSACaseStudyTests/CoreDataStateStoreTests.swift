//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class CoreDataStateStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyStates() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    func test_retrieve_hasNoSideEffect_afterReturningEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .success([]))
        expect(sut, toCompleteWith: .success([]))
    }
    
    func test_retrieve_completesWithStatesWhenNotEmpty() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        sut.insert(state1, completion: { _ in })
        
        expect(sut, toCompleteWith: .success([state1]))
    }
    
    func test_retrieve_completeWithMultipleStatesAfterMultipleInsertions() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        let state3 = makeState(name: "Vermont", taxValue: 0.1)
        
        sut.insert(state1, completion: { _ in })
        sut.insert(state2, completion: { _ in })
        sut.insert(state3, completion: { _ in })
        
        expect(sut, toCompleteWith: .success([state1, state2, state3]))
    }
    
    // Helpers
    func makeSUT() -> CoreDataStateStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStateStore(storeURL: storeURL)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func expect(_ sut: CoreDataStateStore, toCompleteWith expectedResult: CoreDataStateStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
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
