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
        case deleteError
        case editError
    }
        
    public init(store: StateStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }

            completion(
                result
                    .mapError({ _ in Error.loadError})
                    .map({ local in local.toModel() })
            )
        }
    }
}

extension StateFeatureUseCase: StateCreator {
    public func create(_ state: State?, completion: @escaping (CreateResult) -> Void) {
        guard let state = state else {
            completion(.failure(Error.createError))
            return
        }
        
        store.insert(state.toLocalState(), completion: { result in
            completion(result.mapError({ _ in Error.createError }))
        })
    }
}

extension StateFeatureUseCase: StateRemover {
    public func remove(_ state: State, completion: @escaping (RemoveResult) -> Void) {
        store.delete(state.toLocalState(), completion: { result in
            completion(result.mapError({ _ in Error.deleteError}))
        })
    }
}

extension StateFeatureUseCase: StateChanger {
    public func change(_ state: State, completion: @escaping (ChangeResult) -> Void) {
        store.edit(state.toLocalState(), completion: { result in
            completion(Result(catching: {
                let local = try result.get()
                
                guard let newState = State(name: local.name, taxValue: local.taxValue) else {
                    throw Error.editError
                }
                
                return newState
            }))
        })
    }
}

private extension State {
    func toLocalState() -> LocalState {
        LocalState(name: self.name.rawValue, taxValue: self.taxValue)
    }
}

private extension Array where Element == LocalState {
    func toModel() -> [State] {
        compactMap {
            State(name: $0.name, taxValue: $0.taxValue)
        }
    }
}
