//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class CoreDataStateStoreTests: XCTestCase {
    // Retrieve
    func test_retrieve_deliversEmptyStates() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveWith: .success([]))
    }
    
    func test_retrieve_hasNoSideEffect_afterReturningEmpty() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveWith: .success([]))
        expect(sut, toRetrieveWith: .success([]))
    }
    
    func test_retrieve_hasNoSideEffect_afterReturningNonEmptyStates() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        sut.insert(state1, completion: { _ in })
        
        expect(sut, toRetrieveWith: .success([state1]))
        expect(sut, toRetrieveWith: .success([state1]))
    }
    
    func test_retrieve_completesWithStatesWhenNotEmpty() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        sut.insert(state1, completion: { _ in })
        
        expect(sut, toRetrieveWith: .success([state1]))
    }
    
    func test_retrieve_completeWithMultipleStatesAfterMultipleInsertions() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        let state3 = makeState(name: "Vermont", taxValue: 0.1)
        
        sut.insert(state1, completion: { _ in })
        sut.insert(state2, completion: { _ in })
        sut.insert(state3, completion: { _ in })
        
        expect(sut, toRetrieveWith: .success([state1, state2, state3]))
    }
    
    // Delete
    func test_delete_deletesState() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        sut.insert(state1, completion: { _ in })
        
        expect(sut, toRetrieveWith: .success([state1]))
        
        sut.delete(state1) { _ in }
        
        expect(sut, toRetrieveWith: .success([]))
    }
    
    func test_delete_doesNotAlterOtherStatesWhenDeletingOneState() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        let state3 = makeState(name: "Vermont", taxValue: 0.1)
        
        sut.insert(state1, completion: { _ in })
        sut.insert(state2, completion: { _ in })
        sut.insert(state3, completion: { _ in })
        
        expect(sut, toRetrieveWith: .success([state1, state2, state3]))
        
        sut.delete(state1) { _ in }
        
        expect(sut, toRetrieveWith: .success([state2, state3]))
    }
    
    func test_operationsRunSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(state1, completion: { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        })

        let op2 = expectation(description: "Operation 2")
        sut.delete(state1) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.insert(state2, completion: { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        })

        waitForExpectations(timeout: 5.0)

        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // Helpers
    func makeSUT() -> CoreDataStateStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStateStore(storeURL: storeURL)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func expect(_ sut: CoreDataStateStore, toRetrieveWith expectedResult: CoreDataStateStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedStates), .success(expectedStates)):
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
