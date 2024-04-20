//
//  StateStore.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation

public protocol StateStore {
    typealias RetrievalCompletion = (Result<[State], Error>) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
