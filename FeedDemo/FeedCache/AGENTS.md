# FeedCache — Agent Instructions

## THIS MODULE IS FULLY STANDALONE
No FeedFeature import. No FeedNetwork import. No UIKit.
CoreData system framework only.
If you find yourself adding any non-system import — stop immediately.

## Key types
- FeedStore — public protocol, retrieve/insert/deleteCachedFeed with completion handlers
- RetrieveCachedFeedResult — public enum (.empty, .found(feed:timestamp:), .failure(Error))
- LocalFeedImage — public struct, cache model (NOT FeedItem — do not conflate)
- CoreDataFeedStore — public class, implements FeedStore via NSPersistentContainer

## Critical distinctions
- LocalFeedImage ≠ FeedItem — these are different types for a reason
- Cache entity has timestamp — FeedImage entity does not
- CoreDataFeedStore is the ONLY concrete FeedStore implementation

## Test architecture (unusual — read carefully)
- Uses protocol-based specs: FeedStoreSpecs + FailableFeedStoreSpecs
- Shared assertion helpers across spec conformances
- NSManagedObjectContext.Stub uses method swizzling to simulate CoreData failures
- Do not remove swizzling — it is intentional test infrastructure

## Test framework
XCTest — two targets:
- FeedStoreTests (spec-based)
- FeedStoreIntegrationTests (file-backed, cross-instance)

## Verify your work
```bash
xcodebuild test -project FeedCache.xcodeproj -scheme FeedCache -destination 'platform=iOS Simulator,name=iPhone 16'
```