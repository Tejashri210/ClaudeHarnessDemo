# FeedDemo — Agent Instructions

## Hard Constraints (read first)
- FeedCache is fully standalone — NO FeedFeature import, ever
- SceneDelegate is the ONLY composition root — no wiring logic anywhere else
- No circular dependencies between modules
- Never expose internal types across module boundaries

## Project Overview
FeedDemo is a modular iOS feed app — 5 independent Xcode projects in a shared workspace.
Each module has its own project.yml (XcodeGen), test suite, and CI pipeline.

## Workspace
FeedDemo.xcworkspace

## Module Map
| Module | Role | AGENTS.md |
|---|---|---|
| FeedFeature | Domain — zero deps | FeedFeature/AGENTS.md |
| FeedNetwork | Networking — Moya + Alamofire | FeedNetwork/AGENTS.md |
| FeedCache | Persistence — CoreData standalone | FeedCache/AGENTS.md |
| FeedUI | Presentation — UIKit | FeedUI/AGENTS.md |
| FeedApp | Composition root | FeedApp/AGENTS.md |

## Build Commands
```bash
# Regenerate all projects
./generate_all.sh

# Build specific module
xcodebuild build -workspace FeedDemo.xcworkspace -scheme FeedNetwork

# Test specific module
xcodebuild test -workspace FeedDemo.xcworkspace -scheme FeedCache -destination 'platform=iOS Simulator,name=iPhone 16'

# Build app
xcodebuild build -workspace FeedDemo.xcworkspace -scheme FeedApp
```

## Test Summary
| Module | Tests | Framework |
|---|---|---|
| FeedFeature | 4 | Swift Testing |
| FeedNetwork | 20 | XCTest |
| FeedCache | 24 | XCTest |
| FeedUI | 13 | XCTest |

## Session Rules
1. Read claude-progress.md first — understand current state before touching code
2. Run xcodebuild test for the affected scheme before and after changes
3. Update claude-progress.md before ending session
4. Update session-handoff.md with decisions made and why