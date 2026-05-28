## Last session
Date: 2026-05-28
Work done: Added FeedApp/AGENTS.md with isolation rules and explicit self-read instruction.

## Decisions made
- SceneDelegate is the only wiring point — composition logic must never leak into modules
- FeedCache explicitly excluded from imports — not part of this composition
- Feed URL hardcoded here — only place it should appear in the codebase

## Verified
- Nothing run yet — tests not executed this session

## Blockers
- Simulator destination not confirmed
- claude-progress.md test counts empty — needs first test run

## Next session starts here
1. Read FeedApp/AGENTS.md
2. Read FeedApp/claude-progress.md
3. Run: xcodebuild test -project FeedApp.xcodeproj -scheme FeedApp
4. Update test counts in claude-progress.md