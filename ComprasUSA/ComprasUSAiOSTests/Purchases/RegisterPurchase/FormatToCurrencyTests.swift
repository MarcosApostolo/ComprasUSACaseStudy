//
//  FormatToCurrencyTests.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 01/05/24.
//

import Foundation
import XCTest

func formatToCurrency(from text: String, locale: Locale = .init(identifier: "en-US")) -> String {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currencyAccounting
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    guard let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) else {
        return ""
    }
    let cleanText = regex.stringByReplacingMatches(
        in: text,
        options: NSRegularExpression.MatchingOptions(rawValue: 0),
        range: NSMakeRange(0, text.count),
        withTemplate: ""
    )
    
    let double = (cleanText as NSString).doubleValue
    
    let number = NSNumber(value: (double / 100))
    
    guard number != 0, let formattedNumber = formatter.string(from: number) else {
        return ""
    }
    
    return formattedNumber
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
    
    func test_returnsFormattedValue_whenReceivingValidNumber() {
        XCTAssertEqual(formatToCurrency(from: "1"), "$0.01")
        XCTAssertEqual(formatToCurrency(from: "$0.12"), "$0.12")
        XCTAssertEqual(formatToCurrency(from: "$1.12"), "$1.12")
        XCTAssertEqual(formatToCurrency(from: "$1.122"), "$11.22")
        XCTAssertEqual(formatToCurrency(from: "$1.1223"), "$112.23")
    }
}
