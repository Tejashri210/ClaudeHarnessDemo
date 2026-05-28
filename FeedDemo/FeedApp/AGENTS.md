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