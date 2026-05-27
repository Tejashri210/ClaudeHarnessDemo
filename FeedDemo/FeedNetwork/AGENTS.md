# FeedNetwork — Agent Instructions

## This module is the networking layer
Depends on FeedFeature protocols only.
No CoreData, no UIKit, no FeedCache imports — ever.

## Key types
- HTTPClient — public protocol, get(from:completion:)
- HTTPClientResult — public typealias, Result<(Data, HTTPURLResponse), Error>
- RemoteFeedLoader — public class, implements FeedLoader
- URLSessionHTTPClient — public class, implements HTTPClient via URLSession
- MoyaHTTPClient — public class, implements HTTPClient via Moya
- FeedItemMapper — internal enum, JSON → FeedItem mapping (never expose)

## Rules
- FeedItemMapper is internal — never make it public
- New HTTP client implementations must conform to HTTPClient protocol
- Remote* prefix for all concrete implementations
- Dependencies via SPM: Moya, Alamofire

## Test framework
XCTest — scheme: FeedNetwork

## Verify your work
```bash
xcodebuild test -project FeedNetwork.xcodeproj -scheme FeedNetwork -destination 'platform=iOS Simulator,name=iPhone 16'
```