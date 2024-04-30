//
//  StateDeletor.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

public protocol StateRemover {
    typealias RemoveResult = Result<Void, Error>
    
    func remove(_ state: State, completion: @escaping (RemoveResult) -> Void)
}
