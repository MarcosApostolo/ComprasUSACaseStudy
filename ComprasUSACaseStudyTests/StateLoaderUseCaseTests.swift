//
//  StateLoaderUseCase.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest

class StateLoaderUseCase {
    
}

final class StateLoaderUseCaseTests: XCTestCase {
    func test_init_doesNotSendMessagesToClient() {
        _ = StateLoaderUseCase()
        let client = Client()
        
        XCTAssertTrue(client.messages.isEmpty)
    }

    // Helpers
    class Client {
        var messages = [String]()
    }
}
