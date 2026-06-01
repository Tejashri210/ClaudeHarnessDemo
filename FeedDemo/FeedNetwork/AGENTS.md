# FeedNetwork — Agent Instructions
Before touching any code in this module, read this entire file.

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
xcodebuild test -project FeedNetwork.xcodeproj -scheme FeedNetwork -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedNetwork scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->
## Before ending this session — mandatory
1. Update FeedNetwork/claude-progress.md
   - Update test counts if tests were run
   - Update current task status
   - Update next steps
2. Update FeedNetwork/session-handoff.md
   - What was done this session
   - Why decisions were made
   - What's next
3. Commit both files before closing Claude Code

<!-- TODO Lecture 06: replace this manual step with a stop hook -->
<!-- Goal: closed loop agent that auto-updates progress and syncs to root -->