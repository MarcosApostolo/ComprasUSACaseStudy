//
//  StateLoader.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

public protocol StateLoader {
    typealias LoadResult = Result<[State], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}
