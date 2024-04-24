//
//  PurchaseLoader.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 24/04/24.
//

public protocol PurchaseLoader {
    typealias LoadResult = Result<[Purchase], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}
