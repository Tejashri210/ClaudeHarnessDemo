# FeedFeature — Agent Instructions
Before touching any code in this module, read this entire file.

## This module is the domain layer
Zero external dependencies. No import except Foundation.
If you find yourself adding any import — stop. You are in the wrong layer.

## Key types
- FeedItem — public struct, domain model
- FeedLoader — public protocol, load(completion:)
- LoadFeedResult — public typealias, Result<[FeedItem], Error>
- FeedImageDataLoader — public protocol, loadImageData(from:completion:)
- ImageLoaderTask — public protocol, cancel()

## Rules
- All types are protocols or value types — no concrete implementations here
- New types added here must be abstract — protocol or struct only

## Test framework
Swift Testing (not XCTest)

## Verify your work
```bash
xcodebuild test -project FeedFeature.xcodeproj -scheme FeedFeature -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedFeature scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->
## Before ending this session — mandatory
1. Update FeedFeature/claude-progress.md
   - Update test counts if tests were run
   - Update current task status
   - Update next steps
2. Update FeedFeature/session-handoff.md
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