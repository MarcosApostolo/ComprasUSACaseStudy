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
    
    public typealias Result = StateStore.RetrievalResult
    
    private static let modelName = "ComprasUSA"
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
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        
        context.perform {
            completion(.success([]))
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

