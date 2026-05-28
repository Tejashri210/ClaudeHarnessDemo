## Last session
Date: 2026-05-28
Work done: Added FeedFeature/AGENTS.md with isolation rules and explicit self-read instruction.

## Decisions made
- Zero dependencies rule stated first — most critical constraint for domain layer
- All types listed explicitly — protocols and value types only, no concrete implementations
- Swift Testing called out separately — different from XCTest used in other modules

## Verified
- Nothing run yet — tests not executed this session

## Blockers
- Simulator destination not confirmed
- claude-progress.md test counts empty — needs first test run

## Next session starts here
1. Read FeedFeature/AGENTS.md
2. Read FeedFeature/claude-progress.md
3. Run: xcodebuild test -project FeedFeature.xcodeproj -scheme FeedFeature
4. Update test counts in claude-progress.md