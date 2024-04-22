//
//  CoreDataStateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation
import CoreData

public class CoreDataStateStore: StateStore, PurchaseStore {
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
    public func retrieve(completion: @escaping StateStore.RetrievalCompletion) {
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

extension CoreDataStateStore {
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

extension CoreDataStateStore {
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

extension CoreDataStateStore {
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

extension CoreDataStateStore {
    public func insert(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.InsertionCompletion) {
        
    }
}
    
extension CoreDataStateStore {
    public func delete(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.DeletionCompletion) {
        
    }
}
    
extension CoreDataStateStore {
    public func retrieve(completion: @escaping PurchaseStore.RetrievalCompletion) {
        
    }
}

extension CoreDataStateStore {
    public func edit(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.EditionCompletion) {
        
    }
}
