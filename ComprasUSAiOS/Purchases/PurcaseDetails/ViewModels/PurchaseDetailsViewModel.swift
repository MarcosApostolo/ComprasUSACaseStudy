//
//  PurchaseDetailsViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import ComprasUSACaseStudy

class PurchaseDetailsViewModel<Image> {
    private var model: Purchase
    private let imageTransformer: (Data) -> Image?
    
    public init(model: Purchase, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageTransformer = imageTransformer
    }
    
    public var productNameLabel: String {
        return model.name
    }
    
    public var image: Image? {
        guard let imageData = model.imageData else {
            return nil
        }
        
        return imageTransformer(imageData)
    }
    
    public var purchaseInfo: [[String: String]] {
        return [[:]]
    }
}
