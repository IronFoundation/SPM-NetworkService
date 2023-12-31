# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added 

- Add `.swiftformat`, `.swift-version`, `.swiftlint.yml` and `.RunSwiftFormatSwiftLint.sh` script - [#16](https://github.com/ios-course/simple-network-service/pull/16)
- Add implementation of the `NetworkService`, `NetworkRouter` protocol - [#14](https://github.com/ios-course/simple-network-service/pull/14)
- Add `NetworkError` enum - [#4](https://github.com/ios-course/simple-network-service/pull/4)
- Add `HTTPMethod`, `HTTPTask` enums, `HTTPAPIEndpoint` protocol, `HTTPHeaders`, `BodyParameters`, `URLParameters` type aliases - [#2](https://github.com/ios-course/simple-network-service/pull/2)
- Add `BodyEncoder` protocol, `JSONBodyEncoder` implementation - [#13](https://github.com/ios-course/simple-network-service/pull/13)
- Add `ParametersEncoder` protocol and `URLParametersEncoder` type - [#15](https://github.com/ios-course/simple-network-service/pull/15)

### Changed

- Improve the implementation of the `NetworkError` enum [#10](https://github.com/ios-course/simple-network-service/pull/10)
