//
//  ViewController.swift
//  iOS Example
//
//  Created by Aaron McTavish on 29/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import AsyncFetcher
import UIKit


final class ViewController: UITableViewController, UITableViewDataSourcePrefetching {

    // MARK: - Properties

    private static let reuseIdentifier = "MovieCell"

    private let imageFetcher = AsyncFetcher<NetworkImageURLWrapper,
                                            UIImage,
                                            NetworkImageFetchOperation>()

    private var items: [Movie] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private var firstAppearance = true


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)

        title = "iTunes Top Movies"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if firstAppearance {
            firstAppearance = false

            fetchMovieFeed()
        }
    }


    // MARK: - UITableViewDataScource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier, for: indexPath)

        guard let movieCell = cell as? MovieTableViewCell else {
            return cell
        }

        let movie = items[indexPath.row]

        configure(cell: movieCell, movie: movie)

        return movieCell
    }


    // MARK: - UITableViewDataSourcePrefetching

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        for indexPath in indexPaths {
            let movie = items[indexPath.row]
            let urlWrapper = NetworkImageURLWrapper(url: movie.artworkURL)

            imageFetcher.fetchAsync(urlWrapper)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        for indexPath in indexPaths {
            let movie = items[indexPath.row]
            let urlWrapper = NetworkImageURLWrapper(url: movie.artworkURL)

            imageFetcher.cancelFetch(urlWrapper.identifier)
        }
    }


    // MARK: - Convenience

    private func configure(cell: MovieTableViewCell, movie: Movie) {
        cell.imageView?.image = nil
        cell.textLabel?.text = movie.name
        cell.representedId = movie.artworkURL.absoluteString

        let representedID = cell.representedId

        let urlWrapper = NetworkImageURLWrapper(url: movie.artworkURL)
        imageFetcher.fetchAsync(urlWrapper) { image in

            // UI update needs to happen on the main thread.
            DispatchQueue.main.async {
                guard cell.representedId == representedID else {
                    return
                }

                if let image = image {
                    cell.imageView?.contentMode = .scaleAspectFit
                    cell.imageView?.image = image
                } else {
//                    imageView.image = failedImage
                }

                cell.setNeedsLayout()
            }
        }
    }

    private func fetchMovieFeed() {
        let urlString = "https://rss.itunes.apple.com/api/v1/gb/movies/top-movies/all/100/explicit.json"
        guard let feedURL = URL(string: urlString) else {
            return
        }

        struct MovieFeed: Codable {
            let results: [Movie]
        }

        struct MovieFeedWrapper: Codable {
            let feed: MovieFeed
        }

        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: feedURL) { [weak self] data, response, error in
            guard error == nil,
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode,
                let data = data else {

                    return
            }

            do {
                let wrapper = try JSONDecoder().decode(MovieFeedWrapper.self, from: data)

                self?.items = wrapper.feed.results
            } catch {}
        }.resume()
    }

}
