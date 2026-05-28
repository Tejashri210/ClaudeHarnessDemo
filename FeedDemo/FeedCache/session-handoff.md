## Last session
Date: 2026-05-28
Work done: Added FeedCache/AGENTS.md with isolation rules and explicit self-read instruction.

## Decisions made
- Isolation rule placed at TOP in caps — lost in the middle rule from Lecture 04
- LocalFeedImage vs FeedItem distinction called out explicitly
- Test swizzling documented — do not remove warning added

## Verified
- Nothing run yet — tests not executed this session

## Blockers
- Simulator destination not confirmed
- claude-progress.md test counts empty — needs first test run

## Next session starts here
1. Read FeedCache/AGENTS.md
2. Read FeedCache/claude-progress.md
3. Run: xcodebuild test -project FeedCache.xcodeproj -scheme FeedCache
4. Update test counts in claude-progress.md