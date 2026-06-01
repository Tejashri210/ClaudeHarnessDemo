# FeedApp — Agent Instructions
Before touching any code in this module, read this entire file.

## This is the composition root only
Zero business logic here — ever.
If you find yourself writing business logic here — stop. It belongs in a module.

## This module imports
- FeedFeature
- FeedNetwork
- FeedUI
- NOT FeedCache — cache is not part of this composition

## Composition wiring (SceneDelegate only)
URLSessionHTTPClient → RemoteFeedLoader (FeedLoader)
RemoteImageDataLoader (FeedImageDataLoader)
↓
FeedUIComposer.feedComposedWith(feedLoader:imageLoader:)
↓
FeedViewController → UINavigationController → UIWindow

## Rules
- SceneDelegate is the ONLY place concrete types are wired together
- No new composition points outside SceneDelegate
- Feed URL: http://localhost:3000/feeds

## Build
```bash
xcodebuild build -project FeedApp.xcodeproj -scheme FeedApp -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedApp scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->

## Before ending this session — mandatory
1. Update FeedApp/claude-progress.md
   - Update test counts if tests were run
   - Update current task status
   - Update next steps
2. Update FeedApp/session-handoff.md
   - What was done this session
   - Why decisions were made
   - What's next
3. Commit both files before closing Claude Code

<!-- TODO Lecture 06: replace this manual step with a stop hook -->
<!-- Goal: closed loop agent that auto-updates progress and syncs to root -->