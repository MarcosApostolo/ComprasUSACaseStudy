//
//  StateSave.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//
public protocol StateCreator {
    typealias CreateResult = Result<Void, Error>
    
    func create(_ state: State, completion: @escaping (CreateResult) -> Void)
}
