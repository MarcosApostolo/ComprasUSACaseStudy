//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public protocol StateLoader {
    typealias LoadResult = Result<[State], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}

public class StateLoaderUseCase: StateLoader {
    let store: StateStore
    
    public enum Error: Swift.Error {
        case loadError
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