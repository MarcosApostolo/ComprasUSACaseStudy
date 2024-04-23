//
//  PurchaseFeatureUseCase.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 23/04/24.
//

import Foundation

public class PurchaseFeatureUseCase {
    let store: PurchaseStore
    
    public init(store: PurchaseStore) {
        self.store = store
    }
}
