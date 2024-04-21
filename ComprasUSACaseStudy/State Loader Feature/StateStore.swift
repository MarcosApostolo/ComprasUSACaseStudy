//
//  StateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public protocol StateStore {
    typealias RetrievalResult = Result<[State], Error>
    typealias InsertionResult = Result<Void, Error>
    typealias DeletionResult = Result<Void, Error>
    
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    typealias InsertionCompletion = (InsertionResult) -> Void
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
    
    func insert(_ state: State, completion: @escaping InsertionCompletion)
    
    func delete(_ state: State, completion: @escaping DeletionCompletion)
}
