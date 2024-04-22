//
//  LocalPurchase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 22/04/24.
//

import Foundation

public struct LocalPurchase {
    public let name: String
    public let imageData: Data?
    public let value: Double
    public let paymentType: String
    public let state: LocalState
    
    public init(name: String, imageData: Data?, value: Double, paymentType: String, state: LocalState) {
        self.name = name
        self.imageData = imageData
        self.value = value
        self.paymentType = paymentType
        self.state = state
    }
}
