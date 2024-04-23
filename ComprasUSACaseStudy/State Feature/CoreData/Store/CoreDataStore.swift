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
        case insertError
        case retrieveError
        case deleteError
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            self.container = try NSPersistentContainer.load(modelName: CoreDataStore.modelName, url: storeURL, model: model)
            self.context = container.newBackgroundContext()
            
            self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
        perform { context in
            completion(Result(catching: {
                let managedPurchase = ManagedPurchase.newInstance(context: context)
                let managedState = ManagedState(context: context)
                                
                guard let state = purchase.state else {
                    throw StoreError.insertError
                }
                
                managedState.name = state.name
                managedState.taxValue = state.taxValue
                
                managedPurchase.id = purchase.id
                managedPurchase.name = purchase.name
                managedPurchase.imageData = purchase.imageData
                managedPurchase.paymentType = purchase.paymentType
                managedPurchase.state = managedState
                managedPurchase.value = purchase.value
                                
                try context.save()
            }))
        }
    }
}
    
extension CoreDataStore {
    public func delete(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.DeletionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let purchaseToBeRemoved = try ManagedPurchase.find(context: context)?.first(where: { managedPurchase in
                    managedPurchase.id == purchase.id
                }) else {
                    throw StoreError.deleteError
                }

                context.delete(purchaseToBeRemoved)
            }))
        }
    }
}
    
extension CoreDataStore {
    public func retrievePurchases(completion: @escaping PurchaseStore.RetrievalCompletion) {
        completion(Result(catching: {
            guard let purchases = try ManagedPurchase.find(context: context)?.compactMap({ managedPurchase in
                return managedPurchase.localPurchase
            }) else {
                return []
            }
            
            return purchases
        }))
    }
}

extension CoreDataStore {
    public func edit(_ purchase: LocalPurchase, completion: @escaping PurchaseStore.EditionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let purchaseToBeEdited = try ManagedPurchase.find(context: context)?.first(where: { managedPurchase in
                    managedPurchase.id == purchase.id
                }) else {
                    throw StoreError.editError
                }
                
                let managedState = ManagedState(context: context)
                
                guard let state = purchase.state else {
                    throw StoreError.editError
                }
                
                managedState.name = state.name
                managedState.taxValue = state.taxValue

                purchaseToBeEdited.imageData = purchase.imageData
                purchaseToBeEdited.name = purchase.name
                purchaseToBeEdited.paymentType = purchase.paymentType
                purchaseToBeEdited.value = purchase.value
                purchaseToBeEdited.state = managedState
                
                try context.save()
                
                return purchaseToBeEdited.localPurchase
            }))
        }
    }
    
    public func retrieveStates() async throws -> StateStore.RetrievalResult {
        Result {
            do {
                guard let states = try ManagedState.find(context: context)?.compactMap({ managedState in
                    return managedState.localState
                }) else {
                    return []
                }
                
                return states
            } catch {
                throw StoreError.retrieveError
            }
        }
    }
}
