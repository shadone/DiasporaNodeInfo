# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.4.0] - 2026-05-04

### Fixed

- `NodeInfoManager` discovery now picks the highest advertised schema
  version per [spec][nodeinfo-protocol] rule 6. Previously the iteration
  order was inverted and v2.0 was preferred over v2.1 when both were
  advertised.
- Treat any `5xx` status code as a transient failure
  (`Error.temporaryUnavailable`) per spec rule 4, not just literal `500`.
  Federated servers behind reverse proxies routinely surface 502 / 503 /
  504 with the same retry semantics. Applied to both the discovery step
  and the schema-fetch step.
- Removed a DEBUG-only `assert` that required discovery responses to be
  `application/json`. Spec rule 5 leaves the content type unspecified
  and some servers serve `application/jrd+json` (RFC 8288); the decoder
  parses the body as JSON regardless.

### Changed

- Dropped a redundant `do { … } catch { throw error }` wrapper in
  `discoverNodeInfoUrlFromWellKnownNodeInfo` and tightened the
  spec-rule comments.

### Added

- 12 new tests covering the discovery / fetch flow in `NodeInfoManager`
  via a `URLProtocol`-based mock `URLSession` — schema version
  selection, 4xx → `unsupported`, 5xx → `temporaryUnavailable`, and
  `application/jrd+json` content type acceptance.

[nodeinfo-protocol]: http://nodeinfo.diaspora.software/protocol.html

## [1.3.0] - 2026-05-04

### Added

- All public schema types (`NodeInfo`, `v2_0/v2_1.NodeInfo`, `Software`,
  `Usage`, `Users`, `Services`, `ProtocolType`, `InboundSite`,
  `OutboundSite`), plus `JSON`, `LenientInt`, and `WellKnownNodeInfo`,
  now conform to `Sendable`.
- `ValueOrUnknown<Value>` gains a conditional `Sendable` conformance
  (where `Value: Sendable, Value.RawValue: Sendable`).
- `LenientInt` gains an `Equatable` conformance.
- New `NodeInfoManager.Error.nonHTTPResponse` case for the previously
  fatal cast-to-`HTTPURLResponse` failure path.

### Changed

- Bumped `swift-tools-version` to 6.0 and the package to Swift 6
  language mode. The previous experimental
  `StrictConcurrency` and `DisableOutwardActorInference` settings are
  subsumed by Swift 6 language mode and have been dropped.
- `NodeInfoManager` is now `@unchecked Sendable` (URLSession + JSONDecoder
  are documented thread-safe; the unchecked qualifier covers iOS 15 /
  macOS 11 where the SDK's own conformance doesn't yet apply).
- Replaced two `fatalError("Huh")` calls in `NodeInfoManager` with a
  thrown `Error.nonHTTPResponse`.
- Replaced a `preconditionFailure()` in `JSON`'s decoder fallback with a
  proper `DecodingError.typeMismatch`.
- Cleaned up redundant `return` keywords in single-expression switch
  cases.
- Fixed output from the cli tool.

### Removed

- The `enableExperimentalFeature("StrictConcurrency")` and
  `enableUpcomingFeature("DisableOutwardActorInference")` per-target
  settings (now implicit at Swift 6 language mode).

## [1.2.0] - 2024-06-07

### Added

- Added Webmention to the list of known protocols.

### Changed

- Relaxed parsing integers to support wordpress platform.
- Updated how we parse the protocols to handle names that are not part of the enum.

### Removed

- none

## [1.1.2] - 2024-06-01

### Changed

- Fixed bundling privacy manifest file

## [1.1.1] - 2024-05-31

### Added

- Added a privacy manifest

### Changed

- Updated Swift tools version from 5.9 to 5.10
- Enabled StrictConcurrency and DisableOutwardActorInference upcoming Swift features

## [1.1.0] - 2024-05-31

### Added

- Added bluesky to inbound/outbound services

### Changed

- Updated how we parse the inbound/outbound services to handle service names that are
not part of the enum. This is source breaking change but considering the old behavior is to
fail parsing nodeinfo, it should be acceptable.

## [1.0.0] - 2023-07-29

Initial release

[unreleased]: https://github.com/shadone/DiasporaNodeInfo/compare/1.4.0...HEAD
[1.4.0]: https://github.com/shadone/DiasporaNodeInfo/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/shadone/DiasporaNodeInfo/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/shadone/DiasporaNodeInfo/compare/1.1.2...1.2.0
[1.1.2]: https://github.com/shadone/DiasporaNodeInfo/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/shadone/DiasporaNodeInfo/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/shadone/DiasporaNodeInfo/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/shadone/DiasporaNodeInfo/releases/tag/1.0.0
