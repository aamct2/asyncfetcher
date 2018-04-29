fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### test_iOS
```
fastlane test_iOS
```

### test_macOS
```
fastlane test_macOS
```

### test_tvOS
```
fastlane test_tvOS
```

### upload_cov
```
fastlane upload_cov
```
Upload code coverage reports (if running on CI)
### verify_swiftpm
```
fastlane verify_swiftpm
```
Runs unit tests using Swift Package Manager

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
