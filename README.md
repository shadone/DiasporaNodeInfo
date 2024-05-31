# Diaspora NodeInfo

[![Swift versions][swift versions badge]][swift versions]
[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]

Implementation of [NodeInfo](https://nodeinfo.diaspora.software) protocol in Swift.

## About Node Info

NodeInfo is an effort to create a standardized way of exposing metadata about a server running one of the distributed social networks. The two key goals are being able to get better insights into the user base of distributed social networking and the ability to build tools that allow users to choose the best-fitting software and server for their needs.

So far, integration of this standard exists for the following software:

- Mastodon
- Lemmy
- Misskey
- PeerTube
- Pixelfed
- ...

and others, see full list on official website https://nodeinfo.diaspora.software

## Features

Supports the latest NodeInfo versions:
- 2.0
- 2.1

These are the most modern and widely used versions of the protocol.

## Usage

DiasporaNodeInfo package comes with a library which you could integrate into your app, as well as a command line tool for quering remote server NodeInfo.

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Foobar",
    dependencies: [
        .package(url: "https://github.com/shadone/DiasporaNodeInfo.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "Foobar",
            dependencies: [
                .product(name: "DiasporaNodeInfo", package: "DiasporaNodeInfo"),
            ]
        ),
    ]
)
```

To use the command line you compile it or run with [Mint](https://github.com/yonaskolb/Mint):

```sh
mint run shadone/DiasporaNodeInfo@main mastodon.social
```

[swift versions]: https://swiftpackageindex.com/shadone/DiasporaNodeInfo
[swift versions badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fshadone%2FDiasporaNodeInfo%2Fbadge%3Ftype%3Dswift-versions
[platforms]: https://swiftpackageindex.com/shadone/DiasporaNodeInfo
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fshadone%2FDiasporaNodeInfo%2Fbadge%3Ftype%3Dplatforms
[documentation]: https://swiftpackageindex.com/shadone/DiasporaNodeInfo/main/documentation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue
