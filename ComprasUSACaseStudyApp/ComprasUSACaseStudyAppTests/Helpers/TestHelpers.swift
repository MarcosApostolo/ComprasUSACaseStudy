//
//  TestHelpers.swift
//  ComprasUSACaseStudyAppTests
//
//  Created by Marcos Amaral on 03/05/24.
//

import Foundation
import ComprasUSACaseStudy

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}

public func makeState(name: String = "california", taxValue: Double = 0.01) -> State {
    return State(name: name, taxValue: taxValue)!
}

public func makeLocalState(name: String = "california", taxValue: Double = 0.01) -> LocalState {
    return LocalState(name: name, taxValue: taxValue)
}

public func makeStateObjects(name: String = "california", taxValue: Double = 0.01) -> (model: State, local: LocalState) {
    return (makeState(name: name, taxValue: taxValue), makeLocalState(name: name, taxValue: taxValue))
}

public func makeLocalPurchase(
    id: UUID = UUID(),
    name: String = "a purchase",
    imageData: Data? = nil,
    value: Double = 10,
    paymentType: String = "card",
    state: LocalState? = LocalState(name: "california", taxValue: 0.01)
) -> LocalPurchase {
    LocalPurchase(
        id: id,
        name: name,
        imageData: imageData,
        value: value,
        paymentType: paymentType,
        state: state
    )
}

public func anyData() -> Data {
    return Data("any data".utf8)
}

public func makePurchase(
    id: UUID = UUID(),
    name: String = "a purchase",
    imageData: Data? = nil,
    value: Double = 10,
    paymentType: PaymentType = .card,
    state: State? = State(name: "california", taxValue: 0.01)
) -> Purchase {
    Purchase(id: id, name: name, imageData: imageData, value: value, paymentType: paymentType, state: state)
}

public func makePurchaseObjects(
    id: UUID = UUID(),
    name: String = "a purchase",
    imageData: Data? = nil,
    value: Double = 10,
    paymentType: PaymentType = .card,
    state: State? = State(name: "california", taxValue: 0.01)
) -> (model: Purchase, local: LocalPurchase) {
    return (makePurchase(
        id: id,
        name: name,
        imageData: imageData,
        paymentType: paymentType,
        state: state
    ), makeLocalPurchase(
        id: id,
        name: name,
        imageData: imageData,
        paymentType: paymentType.rawValue,
        state: state?.toLocal
    ))
}

private extension State {
    var toLocal: LocalState {
        LocalState(
            name: self.name.rawValue,
            taxValue: self.taxValue
        )
    }
}
