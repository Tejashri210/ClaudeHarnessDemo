## Last session
Date: 2026-05-28
Work done: Added FeedNetwork/AGENTS.md with isolation rules and explicit self-read instruction.

## Decisions made
- FeedItemMapper kept internal — explicitly documented to prevent accidental exposure
- Two HTTPClient implementations documented — URLSession and Moya both valid, neither preferred
- Remote* naming prefix documented — Claude must follow this for any new implementations

## Verified
- Nothing run yet — tests not executed this session

## Blockers
- Simulator destination not confirmed
- claude-progress.md test counts empty — needs first test run

## Next session starts here
1. Read FeedNetwork/AGENTS.md
2. Read FeedNetwork/claude-progress.md
3. Run: xcodebuild test -project FeedNetwork.xcodeproj -scheme FeedNetwork
4. Update test counts in claude-progress.md