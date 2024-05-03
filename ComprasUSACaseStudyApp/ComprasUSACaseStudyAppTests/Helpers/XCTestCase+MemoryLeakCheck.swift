//
//  XCTestCase+MemoryLeakCheck.swift
//  ComprasUSACaseStudyAppTests
//
//  Created by Marcos Amaral on 03/05/24.
//

import XCTest

extension XCTestCase {
    func checkForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
