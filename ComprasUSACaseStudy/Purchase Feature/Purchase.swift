//
//  Purchase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 24/04/24.
//
import Foundation

public struct Purchase: Equatable {
    public let id: UUID
    public let name: String
    public let imageData: Data?
    public let value: Double
    public let paymentType: PaymentType
    public let state: State?
    
    public init(id: UUID, name: String, imageData: Data?, value: Double, paymentType: PaymentType, state: State?) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.value = value
        self.paymentType = paymentType
        self.state = state
    }
}
