# Diaspora NodeInfo

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

DisporaNodeInfo package comes with a library which you could integrate into your app, as well as a command line tool for quering remote server NodeInfo.

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
