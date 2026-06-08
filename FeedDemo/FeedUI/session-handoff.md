## Last session
Date: 2026-06-04
Work done: Lecture 06 complete — CLAUDE.md and init.sh added. session-handoff.md added.

## Last commit
<!-- hash + message from git log -1 -->

## Decisions made
- FeedUIComposer is the only public composition point — all other types internal
- WeakRefVirtualProxy rule documented — retain cycle prevention is non-negotiable
- Internal types listed explicitly — Claude must never make them public
- CLAUDE.md single job — run init.sh only

## Verified
- CLAUDE.md added
- init.sh added
- session-handoff.md added

## Blockers
- Simulator destination not confirmed
- Tests not yet run — counts empty

## Next session starts here
1. Read FeedUI/AGENTS.md
2. Read FeedUI/claude-progress.md
3. Run: xcodebuild test -project FeedUI.xcodeproj -scheme FeedUI
4. Update test counts in claude-progress.md