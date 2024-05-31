# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added a privacy manifest

### Changed

- Updated Swift tools version from 5.9 to 5.10
- Enabled StrictConcurrency and DisableOutwardActorInference upcoming Swift features

### Removed

- none

## [1.1.0] - 2024-05-31

### Added

- Added bluesky to inbound/outbound services

### Changed

- Updated how we parse the inbound/outbound services to handle service names that are
not part of the enum. This is source breaking change but considering the old behavior is to
fail parsing nodeinfo, it should be acceptable.

## [1.0.0] - 2023-07-29

Initial release

[unreleased]: https://github.com/shadone/DiasporaNodeInfo/compare/1.1.0...HEAD
[1.1.0]: https://github.com/shadone/DiasporaNodeInfo/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/shadone/DiasporaNodeInfo/releases/tag/1.0.0
