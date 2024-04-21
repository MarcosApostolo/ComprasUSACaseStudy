//
//  StoreSpy.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 21/04/24.
//

import Foundation
import ComprasUSACaseStudy

class StoreSpy: StateStore {
    var retrievalCompletions = [RetrievalCompletion]()
    var insertionCompletions = [InsertionCompletion]()
    var deletionCompletions = [DeletionCompletion]()
    var editionCompletions = [EditionCompletion]()
    
    var newStatesAfterEdit = [State]()
}

extension StoreSpy {
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

extension StoreSpy {
    func insert(_ state: State, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
    }
    
    func completeCreate(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}

extension StoreSpy {
    func edit(_ state: State, completion: @escaping EditionCompletion) {
        editionCompletions.append(completion)
        newStatesAfterEdit.append(state)
    }
    
    func completeEditon(with error: Error, at index: Int = 0) {
        editionCompletions[index](.failure(error))
    }
    
    func completeEditionSuccessfully(at index: Int = 0) {
        editionCompletions[index](.success(newStatesAfterEdit[index]))
    }
}

extension StoreSpy {
    func delete(_ state: State, completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
}
