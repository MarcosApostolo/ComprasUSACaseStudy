//
//  FormatToCurrencyTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import XCTest
@testable import ComprasUSAiOS

final class FormatToCurrencyTests: XCTestCase {
    func test_returnsEmpty_whenEmptyText() {
        let value = formatToCurrency(from: "")
        
        XCTAssertTrue(value.isEmpty)
    }
    
    func test_returnsEmpty_whenReceivingNonNumericValuesOrSymbols() {
        let value = formatToCurrency(from: "?!@#_+ˆ&%(")
        
        XCTAssertEqual(value, "")
    }
    
    func test_returnsFormattedValue_whenReceivingValidNumber() {
        XCTAssertEqual(formatToCurrency(from: "1"), "$0.01")
        XCTAssertEqual(formatToCurrency(from: "$0.12"), "$0.12")
        XCTAssertEqual(formatToCurrency(from: "$1.12"), "$1.12")
        XCTAssertEqual(formatToCurrency(from: "$1.122"), "$11.22")
        XCTAssertEqual(formatToCurrency(from: "$1.1223"), "$112.23")
    }
}
