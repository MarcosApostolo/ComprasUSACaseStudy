//
//  PurchaseFeatureUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 23/04/24.
//

import Foundation

public protocol PurchaseCreator {
    typealias CreateResult = Result<Void, Error>
    
    func create(_ purchase: Purchase, completion: @escaping (CreateResult) -> Void)
}

public class PurchaseFeatureUseCase: PurchaseLoader {
    let store: PurchaseStore
    
    public enum Error: Swift.Error {
        case loadError
        case createError
    }
    
    public init(store: PurchaseStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrievePurchases(completion: { result in
            completion(
                result
                    .mapError({ _ in Error.loadError})
                    .map({ localState in localState.toModel() })
            )
        })
    }
}

extension PurchaseFeatureUseCase: PurchaseCreator {
    public func create(_ purchase: Purchase, completion: @escaping (CreateResult) -> Void) {
        store.insert(purchase.toLocal, completion: { result in
            completion(result.mapError({ _ in Error.createError }))
        })
    }
}

private extension Array where Element == LocalPurchase {
    func toModel() -> [Purchase] {
        compactMap {
            if let state = $0.state {
                return Purchase(
                    id: $0.id,
                    name: $0.name,
                    imageData: $0.imageData,
                    value: $0.value,
                    paymentType: PaymentType(rawValue: $0.paymentType)!,
                    state: State(name: state.name, taxValue: state.taxValue))
            }
            
            return Purchase(
                id: $0.id,
                name: $0.name,
                imageData: $0.imageData,
                value: $0.value,
                paymentType: PaymentType(rawValue: $0.paymentType)!,
                state: nil
            )
        }
    }
}

private extension Purchase {
    var toLocal: LocalPurchase {
        if let state = self.state {
            return LocalPurchase(
                id: self.id,
                name: self.name,
                imageData: self.imageData,
                value: self.value,
                paymentType: self.paymentType.rawValue,
                state: LocalState(
                    name: state.name.rawValue,
                    taxValue: state.taxValue
                )
            )
        }
        
        return LocalPurchase(
            id: self.id,
            name: self.name,
            imageData: self.imageData,
            value: self.value,
            paymentType: self.paymentType.rawValue,
            state: nil
        )
    }
}
