//
//  CoreDataStateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation
import CoreData

public class CoreDataStore: StateStore, PurchaseStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
        
    private static let modelName = "PurchaseTransactions"
    private static let model = NSManagedObjectModel.with(modelName: modelName, bundle: Bundle(for: CoreDataStore.self))
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
        case editError
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            self.container = try NSPersistentContainer.load(modelName: CoreDataStore.modelName, url: storeURL, model: model)
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

extension CoreDataStore {
    public func retrieve(completion: @escaping StateStore.RetrievalCompletion) {
        retrieveStates(completion: completion)
    }
    
    public func retrieveStates(completion: @escaping StateStore.RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let states = try ManagedState.find(context: context)?.compactMap({ managedState in
                    return managedState.localState
                }) else {
                    return []
                }
                
                return states
            }))}
    }
}

extension CoreDataStore {
    public func insert(_ state: LocalState, completion: @escaping StateStore.InsertionCompletion) {
        perform { context in
            completion(Result(catching: {
                let managedState = ManagedState.newInstance(context: context)
                
                managedState.name = state.name
                managedState.taxValue = state.taxValue
                
                try context.save()
            }))
        }
    }
}

extension CoreDataStore {
    public func delete(_ state: LocalState, completion: @escaping StateStore.DeletionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let stateToBeRemoved = try ManagedState.find(context: context)?.first(where: { managedState in
                    managedState.name == state.name
                }) else {
                    return
                }

                context.delete(stateToBeRemoved)
            }))
        }
    }
}

extension CoreDataStore {
    public func edit(_ state: LocalState, completion: @escaping StateStore.EditionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let stateToBeEdited = try ManagedState.find(context: context)?.first(where: { managedState in
                    managedState.name == state.name
                }) else {
                    throw StoreError.editError
                }

                stateToBeEdited.taxValue = state.taxValue
                
                try context.save()
                
                return stateToBeEdited.localState
            }))
        }
    }
}

extension CoreDataStore {
    public func insert(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.InsertionCompletion) {
        
    }
}
    
extension CoreDataStore {
    public func delete(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.DeletionCompletion) {
        
    }
}
    
extension CoreDataStore {
    public func retrieve(completion: @escaping PurchaseStore.RetrievalCompletion) {
        
    }
}

extension CoreDataStore {
    public func edit(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.EditionCompletion) {
        
    }
}
