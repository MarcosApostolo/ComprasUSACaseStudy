//
//  StateDeletor.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

import Foundation

public protocol StateRemover {
    typealias RemovalResult = Result<Void, Error>
    
    func remove(_ state: State, completion: @escaping (RemovalResult) -> Void)
}
