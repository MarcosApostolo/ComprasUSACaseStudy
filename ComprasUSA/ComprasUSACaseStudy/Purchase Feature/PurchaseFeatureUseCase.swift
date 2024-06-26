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
        case createError
        case removeError
        case changeError
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

extension PurchaseFeatureUseCase: PurchaseRemover {
    public func remove(_ purchase: Purchase, completion: @escaping (RemoveResult) -> Void) {
        store.delete(purchase.toLocal, completion: { result in
            completion(result.mapError({ _ in Error.removeError }))
        })
    }
}

extension PurchaseFeatureUseCase: PurchaseChanger {
    public func change(_ purchase: Purchase, completion: @escaping (ChangeResult) -> Void) {
        store.edit(purchase.toLocal, completion: { result in
            switch result {
            case .failure:
                completion(.failure(Error.changeError))
            case let .success(local):
                guard let paymentType = PaymentType(rawValue: local.paymentType) else {
                    completion(.failure(Error.changeError))
                    return
                }
                
                guard let localState = local.state, let newState = State(name: localState.name, taxValue: localState.taxValue) else {
                    completion(
                        .success(
                            Purchase(
                                id: local.id,
                                name: local.name,
                                imageData: local.imageData,
                                value: local.value,
                                paymentType: paymentType,
                                state: nil
                            )
                        )
                    )
                    return
                }
                
                completion(
                    .success(
                        Purchase(
                            id: local.id,
                            name: local.name,
                            imageData: local.imageData,
                            value: local.value,
                            paymentType: paymentType,
                            state: newState
                        )
                    )
                )
            }
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
