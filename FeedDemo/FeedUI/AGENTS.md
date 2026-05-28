# FeedUI — Agent Instructions
Before touching any code in this module, read this entire file.

## This module is the presentation layer
Depends on FeedFeature protocols only.
No FeedNetwork, no FeedCache, no direct data fetching.
UI drives through protocols — never through concrete implementations.

## Key types (public)
- FeedUIComposer — public class, ONLY composition point for this module
- FeedViewController — public class, UITableViewController

## Key types (internal — must stay internal)
- FeedPresenter — coordinates loading state → view updates
- FeedImagePresenter — generic presenter for image cells
- FeedCellController — manages one table view cell lifecycle
- FeedLoadingView — protocol, display(_ isLoading: Bool)
- FeedView — protocol, display(_ feed: [FeedItem])
- FeedImageView — protocol, associated type Image
- WeakRefVirtualProxy — breaks retain cycles on view references

## Rules
- FeedUIComposer is the ONLY public composition point — nothing else composes here
- Always use WeakRefVirtualProxy on view references to prevent retain cycles
- Internal types must never be made public
- No business logic in view controllers — presenters handle all state

## Test framework
XCTest — scheme: FeedUI

## Verify your work
```bash
xcodebuild test -project FeedUI.xcodeproj -scheme FeedUI -destination 'platform=iOS Simulator,name=iPhone 17'
```
<!--- OR
Run tests using the FeedUI scheme defined in project.yml
Verifying everytime seems overkill. We will evaluate this when we add evaluator-rubric in next lectures --->