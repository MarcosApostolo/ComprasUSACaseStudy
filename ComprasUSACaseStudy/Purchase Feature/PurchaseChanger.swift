//
//  PurchaseChanger.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 25/04/24.
//
public protocol PurchaseChanger {
    typealias ChangeResult = Result<Purchase, Error>
    
    func change(_ purchase: Purchase, completion: @escaping (ChangeResult) -> Void)
}
