//
//  CoreDataStateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation
import CoreData

public class CoreDataStateStore: StateStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
        
    private static let modelName = "PurchaseTransactions"
    private static let model = NSManagedObjectModel.with(modelName: modelName, bundle: Bundle(for: CoreDataStateStore.self))
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
        case editError
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataStateStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            self.container = try NSPersistentContainer.load(modelName: CoreDataStateStore.modelName, url: storeURL, model: model)
            self.context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

extension CoreDataStateStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let states = try ManagedState.find(context: context)?.compactMap({ managedState in
                    return managedState.state
                }) else {
                    return []
                }
                
                return states
            }))}
    }
}

extension CoreDataStateStore {
    public func insert(_ state: State, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result(catching: {
                let managedState = ManagedState.newInstance(context: context)
                
                managedState.name = state.name.rawValue
                managedState.taxValue = state.taxValue
                
                try context.save()
            }))
        }
    }
}

extension CoreDataStateStore {
    public func delete(_ state: State, completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let stateToBeRemoved = try ManagedState.find(context: context)?.first(where: { managedState in
                    managedState.name == state.name.rawValue
                }) else {
                    return
                }

                context.delete(stateToBeRemoved)
            }))
        }
    }
}

extension CoreDataStateStore {
    public func edit(_ state: State, completion: @escaping EditionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let stateToBeEdited = try ManagedState.find(context: context)?.first(where: { managedState in
                    managedState.name == state.name.rawValue
                }) else {
                    throw StoreError.editError
                }

                stateToBeEdited.taxValue = state.taxValue
                
                try context.save()
                
                guard let newState = stateToBeEdited.state else {
                    throw StoreError.editError
                }
                
                return newState
            }))
        }
    }
}

