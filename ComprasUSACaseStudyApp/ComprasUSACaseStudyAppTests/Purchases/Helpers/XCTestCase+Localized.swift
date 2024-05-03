//
//  PurchaseListViewController+Localized.swift
//  ComprasUSAiOSTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import ComprasUSAiOS

extension XCTestCase {
    func localized(_ key: String, table: String = "Purchase", bundle: Bundle = Bundle(for: PurchasesListViewController.self), file: StaticString = #file, line: UInt = #line) -> String {
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
