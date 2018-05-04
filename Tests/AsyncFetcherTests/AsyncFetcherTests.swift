//
//  AsyncFetcherTests.swift
//  AsyncFetcherTests
//
//  Created by Aaron McTavish on 28/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

@testable import AsyncFetcher
import XCTest

class AsyncFetcherTests: XCTestCase {


    // MARK: - Properties

    static var allTests = [
        ("testCompletionHandlerCallback", testCompletionHandlerCallback)
    ]


    // MARK: - Tests

    func testCompletionHandlerCallback() {
        // Given
        let fetcher = AsyncFetcher<OperationInputMock,
                                   OperationOutputMock,
                                   OperationMock>()

        let input = OperationInputMock()

        // When
        let completionExpectation = expectation(description: "CompletionExpectation")
        fetcher.fetchAsync(input) { _ in
            completionExpectation.fulfill()
        }

        // Then
        #if os(Linux)
            waitForExpectations(timeout: 5, handler: nil)
        #else
            let result = XCTWaiter.wait(for: [completionExpectation], timeout: 5)

            if result != .completed {
                XCTFail("Expectation not met. Result: \(result)")
            }
        #endif
    }

}
