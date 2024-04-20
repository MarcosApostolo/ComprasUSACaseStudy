//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

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
                
        expect(sut, toCompleteWith: .failure(StateLoaderUseCase.Error.loadError)) {
            store.completeRetrieval(with: anyNSError())
        }
    }
    
    func test_load_completesWithStates() {
        let (sut, store) = makeSUT()
        let state1 = State(name: "Any name", taxValue: 1.0)
        
        expect(sut, toCompleteWith: .success([state1])) {
            store.completeRetrievalSuccessfully(with: [state1])
        }
    }
    
    func test_load_completesWithEmptyStates() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalSuccessfully(with: [])
        }
    }
    
    func test_shouldNotDeliverResultAfterSUTDeallocation() {
        let store = StoreSpy()
        var sut: StateLoaderUseCase? = StateLoaderUseCase(store: store)
        let state1 = State(name: "Any name", taxValue: 1.0)
        
        var receivedResult = [StateLoaderUseCase.LoadResult]()
        
        sut?.load { result in
            receivedResult.append(result)
        }
        
        sut = nil
        
        store.completeRetrievalSuccessfully(with: [state1])
                        
        XCTAssertTrue(receivedResult.isEmpty)
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
        var retrievalCompletions = [RetrievalCompletion]()
        
        func retrieve(completion: @escaping RetrievalCompletion) {
            retrievalCompletions.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](.failure(error))
        }
        
        func completeRetrievalSuccessfully(with states: [State], at index: Int = 0) {
            retrievalCompletions[index](.success(states))
        }
    }
    
    func expect(_ sut: StateLoaderUseCase, toCompleteWith expectedResult: StateLoaderUseCase.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for action to finish")
        
        sut.load { receivedResult in
            switch(expectedResult, receivedResult) {
            case let (.success(expecedItems), .success(receivedItems)):
                XCTAssertEqual(expecedItems, receivedItems, file: file, line: line)
            case let (.failure(expectedError as StateLoaderUseCase.Error), .failure(receivedError as StateLoaderUseCase.Error)):
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

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}
