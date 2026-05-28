# FeedDemo

A dummy legacy iOS project for experimenting with Claude Code harness engineering.

---

## What's in this repo

### FeedServer
Node.js server with dummy feed data.
Runs on http://localhost:3000/feeds

### FeedDemo (iOS app)
Modular iOS app with 5 framework modules:
- **FeedFeature** — domain layer
- **FeedNetwork** — networking (Moya + Alamofire)
- **FeedCache** — persistence (CoreData)
- **FeedUI** — presentation (UIKit)
- **FeedApp** — composition root

```bash
cd FeedDemo
./generate_all.sh
open FeedDemo.xcworkspace
```
Select `FeedApp` scheme in Xcode and run.

### FeedDemo/Docs
Findings and notes from the harness experiment.