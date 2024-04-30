//
//  State.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public struct State: Equatable, Hashable {
    public let name: USAStates
    public let taxValue: Double
    
    public init?(name: String, taxValue: Double) {
        guard let state = USAStates(rawValue: name) else {
            return nil
        }
        
        self.name = state
        self.taxValue = taxValue
    }
}
