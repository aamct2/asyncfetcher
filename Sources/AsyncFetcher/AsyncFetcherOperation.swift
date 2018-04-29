//
//  AsyncFetcherOperation.swift
//  AsyncFetcher
//
//  Created by Aaron McTavish on 06/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import Foundation

public protocol AsyncFetcherOperationInput {
    associatedtype IdentifierType: AnyObject, Hashable

    /// A unique identifier for the Input. This is used as the `key` when caching.
    var identifier: IdentifierType { get }
}

open class AsyncFetcherOperation<Input: AsyncFetcherOperationInput, Output: AnyObject>: Operation {

    // MARK: - Properties

    /// The input that the operation is fetching data for.
    public let input: Input

    /// The data that has been fetched by this operation.
    public var fetchedData: Output?


    // MARK: - Initialization

    public required init(input: Input) {
        self.input = input
    }

    open override var isAsynchronous: Bool {
        return true
    }

}
