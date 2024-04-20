//
//  TestHelpers.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import Foundation
import ComprasUSACaseStudy

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}

public func makeState(name: String = "California", taxValue: Double = 0.01) -> State {
    return State(name: name, taxValue: taxValue)
}
