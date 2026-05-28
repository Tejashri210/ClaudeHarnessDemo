# FeedDemo — Root Agent Instructions

## Hard Constraints (read first)
- FeedCache is fully standalone — NO FeedFeature import, ever
- SceneDelegate is the ONLY composition root — no wiring logic anywhere else
- No circular dependencies between modules
- Never expose internal types across module boundaries

## This is a multi-module project
Each module has its own AGENTS.md with local rules.

For single-module work:
→ Go directly to that module's AGENTS.md
→ Do not read this file further

For cross-module work:
→ Read ARCHITECTURE.md for dependency graph
→ Read each affected module's AGENTS.md before touching its code

## Module agents
| Module | Responsibility | Rules |
|---|---|---|
| FeedFeature | Domain — zero deps | FeedFeature/AGENTS.md |
| FeedNetwork | Networking — Moya + Alamofire | FeedNetwork/AGENTS.md |
| FeedCache | Persistence — CoreData standalone | FeedCache/AGENTS.md |
| FeedUI | Presentation — UIKit | FeedUI/AGENTS.md |
| FeedApp | Composition root only | FeedApp/AGENTS.md |

## Build commands
```bash
# Regenerate all projects
./generate_all.sh

# Build app
xcodebuild build -project FeedApp.xcodeproj -scheme FeedApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Session rules
1. Read claude-progress.md — understand current state before anything else (WIP)
2. Read ARCHITECTURE.md — understand module boundaries
3. Run tests before and after changes
4. Update claude-progress.md and session-handoff.md before ending session (WIP)
5. Before starting any task, read the relevant module AGENTS.md first
