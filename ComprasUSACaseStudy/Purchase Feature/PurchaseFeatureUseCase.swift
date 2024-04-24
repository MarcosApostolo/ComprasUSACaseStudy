//
//  PurchaseFeatureUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 23/04/24.
//

import Foundation

public class PurchaseFeatureUseCase: PurchaseLoader {
    let store: PurchaseStore
    
    public enum Error: Swift.Error {
        case loadError
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

private extension Array where Element == LocalPurchase {
    func toModel() -> [Purchase] {
        compactMap {
            if let stateName = $0.state?.name, let stateTaxValue = $0.state?.taxValue {
                return Purchase(
                    id: $0.id,
                    name: $0.name,
                    imageData: $0.imageData,
                    value: $0.value,
                    paymentType: PaymentType(rawValue: $0.paymentType)!,
                    state: State(name: stateName, taxValue: stateTaxValue))
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
