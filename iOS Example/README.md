# AsyncFetcher iOS Example

This demo app fetches the Top 100 Movies from iTunes and displays them in a table view. The cover images for the films are fetched and cached using the `AsyncFetcher` framework.

A sample implementation of a [`AsyncFetcherOperation`][asyncfetcheroperation] can be found in [`NetworkImageFetchOperation`][networkimagefetchoperation]. The corresponding specialization of [`AsyncFetcher`][asyncfetcher] is the `imageFetcher` property in [`ViewController`][viewcontroller].

<!-- Links -->

[asyncfetcher]: ./../Sources/AsyncFetcher/AsyncFetcher.swift
[asyncfetcheroperation]: ./../Sources/AsyncFetcher/AsyncFetcherOperation.swift
[networkimagefetchoperation]: ./iOS%20Example/NetworkImageFetchOperation.swift
[viewcontroller]: ./iOS%20Example/ViewController.swift
