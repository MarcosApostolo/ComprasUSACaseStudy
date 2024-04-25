//
//  PurchaseCreator.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 25/04/24.
//
public protocol PurchaseCreator {
    typealias CreateResult = Result<Void, Error>
    
    func create(_ purchase: Purchase, completion: @escaping (CreateResult) -> Void)
}
