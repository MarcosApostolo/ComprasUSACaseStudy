//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public class StateFeatureUseCase: StateLoader {
    let store: StateStore
    
    public enum Error: Swift.Error {
        case loadError
        case createError
    }
        
    public init(store: StateStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }

            completion(result.mapError({ _ in Error.loadError}))
        }
    }
}

extension StateFeatureUseCase: StateCreator {
    public func create(_ state: State?, completion: @escaping (CreateResult) -> Void) {
        guard let state = state else {
            completion(.failure(Error.createError))
            return
        }
        
        store.insert(state, completion: { result in
            completion(result.mapError({ _ in Error.createError }))
        })
    }
}

extension StateFeatureUseCase: StateRemover {
    public func remove(_ state: State, completion: @escaping (RemovalResult) -> Void) {
        store.delete(state, completion: { _ in })
    }
}
