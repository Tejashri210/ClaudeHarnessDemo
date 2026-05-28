## Last session
Date: 2026-05-28
Work done: Added FeedUI/AGENTS.md with isolation rules and explicit self-read instruction.

## Decisions made
- FeedUIComposer is the only public composition point — all other types internal
- WeakRefVirtualProxy rule documented — retain cycle prevention is non-negotiable
- Internal types listed explicitly — Claude must never make them public

## Verified
- Nothing run yet — tests not executed this session

## Blockers
- Simulator destination not confirmed
- claude-progress.md test counts empty — needs first test run

## Next session starts here
1. Read FeedUI/AGENTS.md
2. Read FeedUI/claude-progress.md
3. Run: xcodebuild test -project FeedUI.xcodeproj -scheme FeedUI
4. Update test counts in claude-progress.md