//
//  PurchaseCellViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import ComprasUSACaseStudy

public class PurchaseCellViewModel {
    private let model: Purchase
    
    public init(model: Purchase) {
        self.model = model
    }
    
    public var name: String {
        model.name
    }
    
    public var value: String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US")
        
        return formatter.string(from: NSNumber(value: model.value)) ?? ""
    }
}
