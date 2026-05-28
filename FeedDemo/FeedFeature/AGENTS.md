# FeedFeature — Agent Instructions
Before touching any code in this module, read this entire file.

## This module is the domain layer
Zero external dependencies. No import except Foundation.
If you find yourself adding any import — stop. You are in the wrong layer.

## Key types
- FeedItem — public struct, domain model
- FeedLoader — public protocol, load(completion:)
- LoadFeedResult — public typealias, Result<[FeedItem], Error>
- FeedImageDataLoader — public protocol, loadImageData(from:completion:)
- ImageLoaderTask — public protocol, cancel()

## Rules
- All types are protocols or value types — no concrete implementations here
- New types added here must be abstract — protocol or struct only

## Test framework
Swift Testing (not XCTest)

## Verify your work
```bash
xcodebuild test -project FeedFeature.xcodeproj -scheme FeedFeature -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedFeature scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->