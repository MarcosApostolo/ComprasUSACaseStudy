//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class StateLoaderUseCaseTests: XCTestCase {
    // MARK: Loader Tests
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
                
        expect(sut, toCompleteWith: .failure(StateFeatureUseCase.Error.loadError)) {
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
        var sut: StateFeatureUseCase? = StateFeatureUseCase(store: store)
        let state1 = State(name: "Any name", taxValue: 1.0)
        
        var receivedResult = [StateFeatureUseCase.LoadResult]()
        
        sut?.load { result in
            receivedResult.append(result)
        }
        
        sut = nil
        
        store.completeRetrievalSuccessfully(with: [state1])
                        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    // MARK: Creator Tests
    func test_create_doesNotSendMessagesOnInit() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.insertionCompletions.count, 0)
    }

    // MARK: Helpers
    func makeSUT() -> (sut: StateFeatureUseCase, store: StoreSpy) {
        let store = StoreSpy()
        let sut = StateFeatureUseCase(store: store)
        
        checkForMemoryLeaks(store)
        checkForMemoryLeaks(sut)
        
        return (sut, store)
    }
    
    class StoreSpy: StateStore {
        var retrievalCompletions = [RetrievalCompletion]()
        var insertionCompletions = [InsertionCompletion]()
                
        func retrieve(completion: @escaping RetrievalCompletion) {
            retrievalCompletions.append(completion)
        }
        
        func insert(_ state: ComprasUSACaseStudy.State, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
        }
        
        func delete(_ state: ComprasUSACaseStudy.State, completion: @escaping DeletionCompletion) {
            
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](.failure(error))
        }
        
        func completeRetrievalSuccessfully(with states: [State], at index: Int = 0) {
            retrievalCompletions[index](.success(states))
        }
        
        func edit(_ state: State, completion: @escaping EditionCompletion) {
            
        }
    }
    
    func expect(_ sut: StateFeatureUseCase, toCompleteWith expectedResult: StateFeatureUseCase.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for action to finish")
        
        sut.load { receivedResult in
            switch(expectedResult, receivedResult) {
            case let (.success(expecedItems), .success(receivedItems)):
                XCTAssertEqual(expecedItems, receivedItems, file: file, line: line)
            case let (.failure(expectedError as StateFeatureUseCase.Error), .failure(receivedError as StateFeatureUseCase.Error)):
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

