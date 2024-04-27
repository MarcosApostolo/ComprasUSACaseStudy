//
//  CombineHelpers.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import Combine
import ComprasUSACaseStudy

public extension PurchaseLoader {
    typealias Publisher = AnyPublisher<[Purchase], Error>
    
    func loadPurchasesPublisher() -> Publisher {
        Deferred {
            Future(self.load)
        }.eraseToAnyPublisher()
    }
}
