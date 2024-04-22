//
//  StateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public protocol StateStore {
    typealias RetrievalResult = Result<[LocalState], Error>
    typealias InsertionResult = Result<Void, Error>
    typealias DeletionResult = Result<Void, Error>
    typealias EditionResult = Result<LocalState, Error>
    
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    typealias InsertionCompletion = (InsertionResult) -> Void
    typealias DeletionCompletion = (DeletionResult) -> Void
    typealias EditionCompletion = (EditionResult) -> Void
    
    @available(*, deprecated)
    func retrieve(completion: @escaping RetrievalCompletion)
    
    func insert(_ state: LocalState, completion: @escaping InsertionCompletion)
    
    func delete(_ state: LocalState, completion: @escaping DeletionCompletion)
    
    func edit(_ state: LocalState, completion: @escaping EditionCompletion)
}
