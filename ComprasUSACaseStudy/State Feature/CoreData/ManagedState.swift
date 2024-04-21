//
//  ManagedState.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

import Foundation
import CoreData

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
    
    var state: State? {
        State(name: self.name, taxValue: self.taxValue)
    }
}
