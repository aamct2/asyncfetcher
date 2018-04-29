# AsyncFetcher iOS Example

This demo app fetches the Top 100 Movies from iTunes and displays them in a table view. The cover images for the films are fetched and cached using the `AsyncFetcher` framework.

A sample implementation of a `AsyncFetcherOperation` can be found in `NetworkImageFetchOperation`. The corresponding specialization of `AsyncFetcher` is the `imageFetcher` property in `ViewController`.
