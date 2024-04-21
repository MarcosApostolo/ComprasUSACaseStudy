//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
@testable import ComprasUSACaseStudy

final class CoreDataStateStoreTests: XCTestCase {
    // MARK: Retrieve Tests
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
                
        prepopulateStore(with: [state1], using: sut)
        
        expect(sut, toRetrieveWith: .success([state1]))
    }
    
    func test_retrieve_completeWithMultipleStatesAfterMultipleInsertions() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        let state3 = makeState(name: "Vermont", taxValue: 0.1)
        
        prepopulateStore(with: [state1, state2, state3], using: sut)

        expect(sut, toRetrieveWith: .success([state1, state2, state3]))
    }
    
    // MARK: Delete Tests
    func test_delete_deletesState() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        prepopulateStore(with: [state1], using: sut)
        
        expect(sut, toRetrieveWith: .success([state1]))
        
        sut.delete(state1) { _ in }
        
        expect(sut, toRetrieveWith: .success([]))
    }
    
    func test_delete_doesNotAlterOtherStatesWhenDeletingOneState() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        let state2 = makeState(name: "New York", taxValue: 0.01)
        let state3 = makeState(name: "Vermont", taxValue: 0.1)
        
        prepopulateStore(with: [state1, state2, state3], using: sut)
        
        expect(sut, toRetrieveWith: .success([state1, state2, state3]))
        
        sut.delete(state1) { _ in }
        
        expect(sut, toRetrieveWith: .success([state2, state3]))
    }
    
    // MARK: Edit Tests
    func test_edit_editState() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        prepopulateStore(with: [state1], using: sut)
        
        expect(sut, toRetrieveWith: .success([state1]))
        
        let newState = makeState(name: "California", taxValue: 0.05)

        sut.edit(newState) { _ in }
        
        expect(sut, toRetrieveWith: .success([newState]))
    }
    
    func test_edit_doesNotAllowChangingName_completesWithError() {
        let sut = makeSUT()
        
        let state1 = makeState(name: "California", taxValue: 0.02)
        
        prepopulateStore(with: [state1], using: sut)
        
        expect(sut, toRetrieveWith: .success([state1]))
        
        let newState = makeState(name: "california", taxValue: 0.02)
        
        let exp = expectation(description: "Wait for edit to finish")
        
        var expectedError = CoreDataStateStore.StoreError.editError

        sut.edit(newState) { result in
            switch result {
            case .success:
                XCTFail("Expected error but got success instead")
            case let .failure(error):
                XCTAssertEqual(error as NSError, expectedError as NSError)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieveWith: .success([state1]))
    }
    
    // MARK: General Tests
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
    
    // MARK: Helpers
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
                let receivedStatesSet = Set(receivedStates)
                let expectedStatesSet = Set(expectedStates)
                XCTAssertEqual(receivedStatesSet, expectedStatesSet, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func prepopulateStore(with states: [State] = [State(name: "California", taxValue: 0.1)], using sut: CoreDataStateStore) {
        states.forEach({ state in
            sut.insert(state, completion: { _ in })
        })
    }
}
