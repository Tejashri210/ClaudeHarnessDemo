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

<img width="423" height="872" alt="Screenshot 2026-05-28 at 12 35 17 PM" src="https://github.com/user-attachments/assets/5b2d3b10-5aea-401b-a83c-4c9a78405500" />
