//
//  OperationMock.swift
//  AsyncFetcherTests
//
//  Created by Aaron McTavish on 01/05/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

@testable import AsyncFetcher
import Foundation


final class OperationInputMock: AsyncFetcherOperationInput {
    var identifier = NSUUID()
}

extension OperationInputMock: Equatable {
    static func == (lhs: OperationInputMock, rhs: OperationInputMock) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

final class OperationOutputMock {

}


final class OperationMock: AsyncFetcherOperation<OperationInputMock, OperationOutputMock> {


    // MARK: - Properties

    private var _executing = false {
        willSet {
            #if os(Linux)
                willChangeValue(forKey: "isExecuting")
            #else
                willChangeValue(for: \OperationMock.isExecuting)
            #endif
        }
        didSet {
            #if os(Linux)
                didChangeValue(forKey: "isExecuting")
            #else
                didChangeValue(for: \OperationMock.isExecuting)
            #endif
        }
    }

    override var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            #if os(Linux)
                willChangeValue(forKey: "isFinished")
            #else
                willChangeValue(for: \OperationMock.isFinished)
            #endif
        }

        didSet {
            #if os(Linux)
                didChangeValue(forKey: "isFinished")
            #else
                didChangeValue(for: \OperationMock.isFinished)
            #endif
        }
    }

    override var isFinished: Bool {
        return fetchedData != nil
    }

    // MARK: - Operation

    override func start() {
        _executing = true

        // Wait for a second to mimic a slow operation.
        Thread.sleep(until: Date().addingTimeInterval(1))

        guard !isCancelled else {
            return
        }

        fetchedData = OperationOutputMock()

        _executing = false
        _finished = true
    }

}
