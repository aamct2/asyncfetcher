//
//  AsyncFetcherOperationTests.swift
//  AsyncFetcherTests
//
//  Created by Aaron McTavish on 04/05/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

@testable import AsyncFetcher
import XCTest

class AsyncFetcherOperationTests: XCTestCase {


    // MARK: - Properties

    static var allTests = [
        ("testOperationInputStored", testOperationInputStored),
        ("testOperationIsAsynchronous", testOperationIsAsynchronous)
    ]


    // MARK: - Tests

    func testOperationInputStored() {
        // Given
        let input = OperationInputMock()

        // When
        let operation = OperationMock(input: input)

        // Then
        XCTAssertEqual(operation.input, input)
    }

    func testOperationIsAsynchronous() {
        // Given
        let input = OperationInputMock()

        // When
        let operation = OperationMock(input: input)

        // Then
        XCTAssertTrue(operation.isAsynchronous)
    }

}
