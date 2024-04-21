//
//  StateChanger.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

public protocol StateChanger {
    typealias ChangeResult = Result<State, Error>
    
    func change(_ state: State, completion: @escaping (ChangeResult) -> Void)
}
