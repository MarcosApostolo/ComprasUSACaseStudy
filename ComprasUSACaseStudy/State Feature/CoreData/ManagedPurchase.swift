//
//  ManagedPurchase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 22/04/24.
//

import Foundation
import CoreData

@objc(ManagedPurchase)
class ManagedPurchase: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var imageData: Data?
    @NSManaged var value: Double
    @NSManaged var paymentType: String
    @NSManaged var state: ManagedState
    
    static func newInstance(context: NSManagedObjectContext) -> ManagedPurchase {
        ManagedPurchase(context: context)
    }
    
    static func find(context: NSManagedObjectContext) throws -> [ManagedPurchase]? {
        let request = NSFetchRequest<ManagedPurchase>(entityName: "ManagedPurchase")
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }

    var localPurchase: LocalPurchase {
        LocalPurchase(
            name: self.name,
            imageData: self.imageData,
            value: self.value,
            paymentType: self.paymentType,
            state: self.state.localState
        )
    }
}
