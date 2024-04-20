//
//  State.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public struct State: Equatable {
    public let name: String
    public let taxValue: Double
    
    public init(name: String, taxValue: Double) {
        self.name = name
        self.taxValue = taxValue
    }
}
