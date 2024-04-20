//
//  StateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public protocol StateStore {
    typealias RetrievalResult = Result<[State], Error>
    
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
