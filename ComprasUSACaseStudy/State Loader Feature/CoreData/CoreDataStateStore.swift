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
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataStateStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            let description = NSPersistentStoreDescription(url: storeURL)
            let container = NSPersistentContainer(name: CoreDataStateStore.modelName, managedObjectModel: model)
            container.persistentStoreDescriptions = [description]
            var loadError: Error?
            container.loadPersistentStores { loadError = $1 }
            try loadError.map { throw $0 }
            
            self.container = container
            self.context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
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
