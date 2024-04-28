//
//  PurchaseCellViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import ComprasUSACaseStudy

public class PurchaseCellViewModel<Image> {
    private let model: Purchase
    private let imageTransformer: (Data) -> Image?
    
    public init(model: Purchase, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageTransformer = imageTransformer
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
    
    public var image: Image? {
        guard let imageData = model.imageData else {
            return nil
        }
        
        return imageTransformer(imageData)
    }
}
