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
                    return State(name: managedState.name, taxValue: managedState.taxValue)
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
                
                managedState.name = state.name
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
    public func edit(_ state: State, completion: @escaping EditionCompletion) {
        perform { context in
            completion(Result(catching: {
                guard let stateToEdited = try ManagedState.find(context: context)?.first(where: { managedState in
                    managedState.name == state.name
                }) else {
                    throw StoreError.editError
                }

                stateToEdited.taxValue = state.taxValue
                
                try context.save()
            }))
        }
    }
}

extension NSManagedObjectModel {
    static func with(modelName: String, bundle: Bundle) -> NSManagedObjectModel? {
        bundle
            .url(forResource: modelName, withExtension: "momd")
            .flatMap({ NSManagedObjectModel(contentsOf: $0) })
    }
}

@objc(ManagedState)
class ManagedState: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var taxValue: Double
    
    static func newInstance(context: NSManagedObjectContext) -> ManagedState {
        ManagedState(context: context)
    }
    
    static func find(context: NSManagedObjectContext) throws -> [ManagedState]? {
        let request = NSFetchRequest<ManagedState>(entityName: "ManagedState")
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
}

extension NSPersistentContainer {
    public static func load(modelName: String, url storeURL: URL, model: NSManagedObjectModel) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return container
    }
}
