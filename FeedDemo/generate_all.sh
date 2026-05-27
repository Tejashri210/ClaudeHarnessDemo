#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PROJECTS=(
    "FeedFeature"
    "FeedNetwork"
    "FeedCache"
    "FeedUI"
    "FeedApp"
)

echo "=== Generating all Xcode projects ==="

for project in "${PROJECTS[@]}"; do
    echo ""
    echo "--- Generating $project ---"
    cd "$SCRIPT_DIR/$project"
    xcodegen generate
done

echo ""
echo "=== Generating workspace ==="

mkdir -p "$SCRIPT_DIR/FeedDemo.xcworkspace"

cat > "$SCRIPT_DIR/FeedDemo.xcworkspace/contents.xcworkspacedata" << 'WORKSPACE'
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "group:FeedFeature/FeedFeature.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:FeedNetwork/FeedNetwork.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:FeedCache/FeedCache.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:FeedUI/FeedUI.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:FeedApp/FeedApp.xcodeproj">
   </FileRef>
</Workspace>
WORKSPACE

echo ""
echo "=== Done. Open FeedDemo.xcworkspace to build. ==="
