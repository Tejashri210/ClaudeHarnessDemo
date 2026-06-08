## Last session
Date: 2026-06-04
Work done: Lecture 06 complete — CLAUDE.md and init.sh added. session-handoff.md added.

## Last commit
<!-- hash + message from git log -1 -->

## Decisions made
- Isolation rule placed at TOP in caps — lost in the middle rule from Lecture 04
- LocalFeedImage vs FeedItem distinction called out explicitly
- Test swizzling documented — do not remove warning added
- CLAUDE.md single job — run init.sh only

## Verified
- CLAUDE.md added
- init.sh added
- session-handoff.md added

## Blockers
- Simulator destination not confirmed
- Tests not yet run — counts empty

## Next session starts here
1. Read FeedCache/AGENTS.md
2. Read FeedCache/claude-progress.md
3. Run: xcodebuild test -project FeedCache.xcodeproj -scheme FeedCache
4. Update test counts in claude-progress.md