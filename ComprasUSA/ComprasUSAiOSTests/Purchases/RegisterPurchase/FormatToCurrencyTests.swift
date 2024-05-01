//
//  FormatToCurrencyTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import XCTest

func formatToCurrency(from text: String) -> String {
    return ""
}

final class FormatToCurrencyTests: XCTestCase {
    func test_returnsEmpty_whenEmptyText() {
        let value = formatToCurrency(from: "")
        
        XCTAssertTrue(value.isEmpty)
    }
    
    func test_returnsEmpty_whenReceivingNonNumericValuesOrSymbols() {
        let value = formatToCurrency(from: "?!@#_+ˆ&%(")
        
        XCTAssertEqual(value, "")
    }
}
