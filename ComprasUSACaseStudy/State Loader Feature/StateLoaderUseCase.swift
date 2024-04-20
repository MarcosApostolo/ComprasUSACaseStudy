//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public class StateLoaderUseCase {
    let store: StateStore
    
    public typealias LoadResult = Result<[State], Error>
    
    public enum Error: Swift.Error {
        case loadError
    }
        
    public init(store: StateStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(states):
                completion(.success(states))
            case .failure:
                completion(.failure(.loadError))
            }
        }
    }
}
