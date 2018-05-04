//
//  AsyncFetcher.swift
//  AsyncFetcher
//
//  Created by Aaron McTavish on 06/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import Foundation


/// Generic class to asynchronously fetch and cache data.
public final class AsyncFetcher<Input: AsyncFetcherOperationInput,
                                Output: AnyObject,
                                FetchOperation: AsyncFetcherOperation<Input, Output>> {

    
    // MARK: - Types

    /// A serial `OperationQueue` to lock access to the `fetchQueue` and `completionHandlers` properties.
    private let serialAccessQueue = OperationQueue()

    /// An `OperationQueue` that contains `AsyncFetcherOperation`s for requested data.
    private let fetchQueue = OperationQueue()

    /// A dictionary of arrays of closures to call when an object has been fetched for an id.
    private var completionHandlers = [Input.IdentifierType: [(Output?) -> Void]]()

    /// An `NSCache` used to store fetched objects.
    private var cache = NSCache<Input.IdentifierType, Output>()

    // MARK: - Initialization

    public init() {
        serialAccessQueue.maxConcurrentOperationCount = 1
    }

    // MARK: - Object fetching

    /// Asynchronously fetches data for a specified `Input`.
    ///
    /// - Parameters:
    ///   - input: The `Intput` to fetch data for.
    ///   - completion: An optional called when the data has been fetched.
    public func fetchAsync(_ input: Input, completion: ((Output?) -> Void)? = nil) {
        // Use the serial queue while we access the fetch queue and completion handlers.
        serialAccessQueue.addOperation {
            // If a completion block has been provided, store it.
            if let completion = completion {
                let handlers = self.completionHandlers[input.identifier, default: []]
                self.completionHandlers[input.identifier] = handlers + [completion]
            }

            self.fetchData(for: input)
        }
    }

    /**
     Returns the previously fetched data for a specified unique identifier.

     - Parameter identifier: The unique identifier of the object to return.
     - Returns: The 'DisplayData' that has previously been fetched or nil.
     */
    public func fetchedData(for identifier: Input.IdentifierType) -> Output? {
        return cache.object(forKey: identifier)
    }

    /**
     Cancels any enqueued asychronous fetches for a specified unique identifer. Completion
     handlers are not called if a fetch is canceled.

     - Parameter identifier: The unique identifier to cancel fetches for.
     */
    public func cancelFetch(_ identifier: Input.IdentifierType) {
        serialAccessQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }

            self.operation(for: identifier)?.cancel()
            self.completionHandlers[identifier] = nil
        }
    }

    // MARK: - Convenience

    /**
     Begins fetching data for the provided `identifier` invoking the associated
     completion handler when complete.

     - Parameter identifier: The unique identifier to fetch data for.
     */
    private func fetchData(for input: Input) {
        // If a request has already been made for the object, do nothing more.
        guard operation(for: input.identifier) == nil else {
            return
        }

        if let data = fetchedData(for: input.identifier) {
            // The object has already been cached; call the completion handler with that object.
            invokeCompletionHandlers(for: input.identifier, with: data)
        } else {
            // Enqueue a request for the object.
            let operation = FetchOperation(input: input)

            // Set the operation's completion block to cache the fetched object and call the associated completion blocks.
            #if os(Linux)
                operation.completionBlock = {
                    guard let fetchedData = operation.fetchedData else {
                        return
                    }

                    self.cache.setObject(fetchedData, forKey: input.identifier)

                    self.serialAccessQueue.addOperation {
                        self.invokeCompletionHandlers(for: input.identifier, with: fetchedData)
                    }
                }
            #else
                operation.completionBlock = { [weak operation] in
                    guard let fetchedData = operation?.fetchedData else {
                        return
                    }

                    self.cache.setObject(fetchedData, forKey: input.identifier)

                    self.serialAccessQueue.addOperation {
                        self.invokeCompletionHandlers(for: input.identifier, with: fetchedData)
                    }
                }
            #endif

            fetchQueue.addOperation(operation)
        }
    }

    /**
     Returns any enqueued `ObjectFetcherOperation` for a specified unique identifier.

     - Parameter identifier: The unique identifier of the operation to return.
     - Returns: The enqueued `ObjectFetcherOperation` or nil.
     */
    private func operation(for identifier: Input.IdentifierType) -> FetchOperation? {
        for case let fetchOperation as FetchOperation in fetchQueue.operations
            where !fetchOperation.isCancelled && fetchOperation.input.identifier == identifier {
                return fetchOperation
        }

        return nil
    }

    /**
     Invokes any completion handlers for a specified unique identifier. Once called,
     the stored array of completion handlers for the unique identifier is cleared.

     - Parameters:
     - identifier: The unique identifier of the completion handlers to call.
     - object: The fetched object to pass when calling a completion handler.
     */
    private func invokeCompletionHandlers(for identifier: Input.IdentifierType,
                                          with fetchedData: Output) {

        let completionHandlers = self.completionHandlers[identifier, default: []]
        self.completionHandlers[identifier] = nil

        for completionHandler in completionHandlers {
            completionHandler(fetchedData)
        }
    }
}
