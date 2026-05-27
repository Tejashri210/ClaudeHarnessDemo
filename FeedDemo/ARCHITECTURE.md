# FeedDemo — Architecture

## Overview
FeedDemo is a modular iOS feed app split into 5 independent Xcode projects managed via a shared workspace. Each framework has its own project.yml (XcodeGen), test suite, and CI pipeline.

## Workspace Structure
FeedDemo.xcworkspace
├── FeedFeature.xcodeproj    (domain types — zero dependencies)
├── FeedNetwork.xcodeproj    (HTTP layer — depends on FeedFeature + Moya)
├── FeedCache.xcodeproj      (persistence — standalone, uses CoreData)
├── FeedUI.xcodeproj         (presentation + UIKit — depends on FeedFeature)
└── FeedApp.xcodeproj        (integration app — depends on FeedFeature, FeedNetwork, FeedUI)

## Dependency Graph

```
FeedFeature  ←──  FeedNetwork
     ↑                 ↓
     └────────  FeedUI     FeedCache (standalone)
                   ↓           
              FeedApp (imports FeedFeature + FeedNetwork + FeedUI)
```

No circular dependencies. FeedCache is fully isolated.

## Module Details

### FeedFeature (Domain Layer)
- Dependencies: None
- Tests: 4 (Swift Testing)
- Key types: FeedItem, FeedLoader, FeedImageDataLoader, ImageLoaderTask, LoadFeedResult

### FeedNetwork (Networking Layer)
- Dependencies: FeedFeature, Moya (SPM), Alamofire (SPM)
- Tests: 20 (XCTest)
- Key types: HTTPClient, RemoteFeedLoader, URLSessionHTTPClient, MoyaHTTPClient
- Internal only: FeedItemMapper (never expose)

### FeedCache (Persistence Layer)
- Dependencies: CoreData (system only) — NO FeedFeature import
- Tests: 24 (XCTest)
- Key types: FeedStore, LocalFeedImage, CoreDataFeedStore, RetrieveCachedFeedResult
- Note: LocalFeedImage is NOT FeedItem — do not conflate

### FeedUI (Presentation Layer)
- Dependencies: FeedFeature only
- Tests: 13 (XCTest)
- Key types: FeedUIComposer (public), FeedViewController (public)
- Internal: FeedPresenter, FeedCellController, WeakRefVirtualProxy — must stay internal

### FeedApp (Composition Root)
- Dependencies: FeedFeature, FeedNetwork, FeedUI (NOT FeedCache)
- Tests: None
- Composition: URLSessionHTTPClient → RemoteFeedLoader + RemoteImageDataLoader → FeedUIComposer → FeedViewController

## Key Patterns
- Protocols at boundaries: FeedLoader, FeedStore, HTTPClient, FeedImageDataLoader
- Composition root: SceneDelegate wires concrete types via FeedUIComposer
- Spec-based testing: FeedStoreSpecs + FailableFeedStoreSpecs protocol hierarchy in FeedCache
- Weak reference proxies: WeakRefVirtualProxy breaks retain cycles between presenters and views
- Adapters: FeedLoaderPresentationAdapter, FeedViewAdapter bridge between layers

## Build System
- XcodeGen — each module has its own project.yml
- Shared workspace: FeedDemo.xcworkspace
- Regenerate all: ./generate_all.sh