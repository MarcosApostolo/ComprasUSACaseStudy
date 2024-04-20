//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest

struct State: Equatable {
    public let name: String
    public let taxValue: Double
}

protocol StateStore {
    typealias RetrievalCompletion = (Result<[State], Error>) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
}

class StateLoaderUseCase {
    let store: StateStore
    
    public typealias LoadResult = Result<[State], Error>
    
    public enum Error: Swift.Error {
        case loadError
    }
        
    init(store: StateStore) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .success(states):
                completion(.success(states))
            case .failure:
                completion(.failure(.loadError))
            }
        }
    }
}

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
                
        expect(sut, toCompleteWith: .failure(.loadError)) {
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
        var receivedResult: StateLoaderUseCase.LoadResult?
        
        let exp = expectation(description: "Wait for action to finish")
        
        sut.load { result in
            receivedResult = result
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedResult, expectedResult)
    }
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}
