# FeedCache — Agent Instructions
Before touching any code in this module, read this entire file.

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
xcodebuild test -project FeedCache.xcodeproj -scheme FeedCache -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedCache scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->

## Before ending this session — mandatory
1. Update FeedCache/claude-progress.md
   - Update test counts if tests were run
   - Update current task status
   - Update next steps
2. Update FeedCache/session-handoff.md
   - What was done this session
   - Why decisions were made
   - What's next
3. Commit both files before closing Claude Code

## Clock-out rule
Before ending any session, update:
- claude-progress.md — test counts
- session-handoff.md — what was done, decisions made, next action

<!-- TODO Lecture 06: replace this manual step with a stop hook -->
<!-- Goal: closed loop agent that auto-updates progress and syncs to root -->