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
        ("testCaching", testCaching),
        ("testCancelation", testCancelation),
        ("testCompletionHandlerCallback", testCompletionHandlerCallback)
    ]


    // MARK: - Tests

    func testCaching() {
        // Given
        let fetcher = AsyncFetcher<OperationInputMock,
                                   OperationOutputMock,
                                   OperationMock>()

        let input = OperationInputMock()
        var result: OperationOutputMock?

        let fetchExpectation = expectation(description: "FetchExpectation")
        fetcher.fetchAsync(input) { output in
            guard let output = output else {
                XCTFail("No output found from fetch.")
                return
            }

            result = output
            fetchExpectation.fulfill()
        }

        #if os(Linux)
            waitForExpectations(timeout: 5, handler: nil)
        #else
            let waiterResult = XCTWaiter.wait(for: [fetchExpectation], timeout: 5)

            if waiterResult != .completed {
                XCTFail("Fetch expectation not met. Expectation result: \(waiterResult)")
            }
        #endif

        // When
        var cachedResult: OperationOutputMock?
        let cacheExpectation = expectation(description: "CacheExpectation")
        fetcher.fetchAsync(input) { output in
            guard let output = output else {
                XCTFail("No output found from fetch.")
                return
            }

            cachedResult = output
            cacheExpectation.fulfill()
        }

        #if os(Linux)
            waitForExpectations(timeout: 5, handler: nil)
        #else
            let cachedWaiterResult = XCTWaiter.wait(for: [cacheExpectation], timeout: 5)

            if cachedWaiterResult != .completed {
                XCTFail("Cached expectation not met. Expectation result: \(cachedWaiterResult)")
            }
        #endif

        // Then
        XCTAssertEqual(result, cachedResult)
    }

    func testCancelation() {
        // Given
        let fetcher = AsyncFetcher<OperationInputMock,
                                   OperationOutputMock,
                                   SlowOperationMock>()

        let input = OperationInputMock()

        // When
        let completionExpectation = expectation(description: "CompletionExpectation")
        fetcher.fetchAsync(input) { _ in
            XCTFail("Operation completed instead of being canceled.")
        }

        // Then
        #if os(Linux)
            sleep(3)
            completionExpectation.fulfill()
            waitForExpectations(timeout: 1, handler: nil)
        #else
            _ = XCTWaiter.wait(for: [completionExpectation], timeout: 3)
        #endif

        fetcher.cancelFetch(input.identifier)
    }

    func testCompletionHandlerCallback() {
        // Given
        let fetcher = AsyncFetcher<OperationInputMock,
                                   OperationOutputMock,
                                   OperationMock>()

        let input = OperationInputMock()

        // Then
        successfulFetch(input: input, fetcher: fetcher)
    }


    // MARK: - Convenience

    private func successfulFetch(input: OperationInputMock,
                                 fetcher: AsyncFetcher<OperationInputMock, OperationOutputMock, OperationMock>,
                                 completion: ((OperationOutputMock) -> Void)? = nil) {

        var result: OperationOutputMock?

        let completionExpectation = expectation(description: "CompletionExpectation")
        fetcher.fetchAsync(input) { output in
            guard let output = output else {
                XCTFail("No output found from fetch.")
                return
            }

            result = output
            completionExpectation.fulfill()
        }

        #if os(Linux)
            waitForExpectations(timeout: 5, handler: nil)
        #else
            let waiterResult = XCTWaiter.wait(for: [completionExpectation], timeout: 5)

            if waiterResult != .completed {
                XCTFail("Expectation not met. Expectation result: \(waiterResult)")
            }
        #endif

        if let result = result {
            completion?(result)
        } else {
            XCTFail("No fetched output.")
        }
    }

}
