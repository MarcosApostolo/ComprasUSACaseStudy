//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class StateFeatureUseCaseTests: XCTestCase {
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
                
        expect(sut, toCompleteLoadWith: .failure(StateFeatureUseCase.Error.loadError)) {
            store.completeRetrieval(with: anyNSError())
        }
    }
    
    func test_load_completesWithStates() {
        let (sut, store) = makeSUT()
        let state1 = makeState()
        
        expect(sut, toCompleteLoadWith: .success([state1])) {
            store.completeRetrievalSuccessfully(with: [state1])
        }
    }
    
    func test_load_completesWithEmptyStates() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteLoadWith: .success([])) {
            store.completeRetrievalSuccessfully(with: [])
        }
    }
    
    func test_shouldNotDeliverResultAfterSUTDeallocation() {
        let store = StoreSpy()
        var sut: StateFeatureUseCase? = StateFeatureUseCase(store: store)
        let state1 = makeState()
        
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
    
    func test_create_sendMessageToStoreWhenOnCreate() {
        let (sut, store) = makeSUT()
        
        sut.create(makeState()) { _ in }
        
        XCTAssertEqual(store.insertionCompletions.count, 1)
    }
    
    func test_create_completesWithErrorOnStoreError() {
        let (sut, store) = makeSUT()
        
        
        expect(sut, toCompleteCreateWith: .failure(StateFeatureUseCase.Error.createError), using: makeState(), when: {
            store.completeCreate(with: anyNSError())
        })
    }
    
    func test_create_completesSuccessfullyOnStoreCreateSuccess() {
        let (sut, store) = makeSUT()
        
        
        expect(sut, toCompleteCreateWith: .success(()), using: makeState(), when: {
            store.completeSuccessfully()
        })
    }

    // MARK: Helpers
    func makeSUT() -> (sut: StateFeatureUseCase, store: StoreSpy) {
        let store = StoreSpy()
        let sut = StateFeatureUseCase(store: store)
        
        checkForMemoryLeaks(store)
        checkForMemoryLeaks(sut)
        
        return (sut, store)
    }
    
    func expect(_ sut: StateFeatureUseCase, toCompleteLoadWith expectedResult: StateFeatureUseCase.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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
    
    func expect(_ sut: StateFeatureUseCase, toCompleteCreateWith expectedResult: StateFeatureUseCase.CreateResult, using state: State, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for action to finish")
        
        sut.create(state) { receivedResult in
            switch(expectedResult, receivedResult) {
            case (.success, .success):
                break
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

