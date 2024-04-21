//
//  CoreDataStateStoreHelpers.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

import Foundation
import CoreData

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

extension NSManagedObjectModel {
    static func with(modelName: String, bundle: Bundle) -> NSManagedObjectModel? {
        bundle
            .url(forResource: modelName, withExtension: "momd")
            .flatMap({ NSManagedObjectModel(contentsOf: $0) })
    }
}
