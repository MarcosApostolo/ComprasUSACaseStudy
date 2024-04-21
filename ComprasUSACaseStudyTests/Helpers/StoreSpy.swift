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
