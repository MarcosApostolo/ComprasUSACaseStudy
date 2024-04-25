//
//  PurchaseRemover.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 25/04/24.
//
public protocol PurchaseRemover {
    typealias RemoveResult = Result<Void, Error>
    
    func remove(_ purchase: Purchase, completion: @escaping (RemoveResult) -> Void)
}
