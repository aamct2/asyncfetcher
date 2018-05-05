//
//  NetworkImageOperation.swift
//  iOS Example
//
//  Created by Aaron McTavish on 29/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import AsyncFetcher
import UIKit


struct NetworkImageURLWrapper: AsyncFetcherOperationInput {
    typealias IdentifierType = NSString

    let url: URL

    var identifier: NSString {
        return url.path as NSString
    }
}

final class NetworkImageFetchOperation: AsyncFetcherOperation<NetworkImageURLWrapper, UIImage> {


    // MARK: - Properties

    private var _executing = false {
        willSet {
            willChangeValue(for: \NetworkImageFetchOperation.isExecuting)
        }
        didSet {
            didChangeValue(for: \NetworkImageFetchOperation.isExecuting)
        }
    }

    override var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValue(for: \NetworkImageFetchOperation.isFinished)
        }

        didSet {
            didChangeValue(for: \NetworkImageFetchOperation.isFinished)
        }
    }

    override var isFinished: Bool {
        return fetchedData != nil
    }

    // MARK: - Operation

    override func start() {
        guard !isCancelled else {
            return
        }

        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: input.url) { [weak self] data, response, error in
            defer {
                self?._executing = false
                self?._finished = true
            }

            guard error == nil,
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode,
                let data = data,
                let image = UIImage(data: data) else {

                    return
            }

            self?.fetchedData = image
        }.resume()

        _executing = true
    }

}
