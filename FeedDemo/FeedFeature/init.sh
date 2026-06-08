#!/bin/bash
# FeedCache — Initialization Script
# Run at the start of every Claude Code session in this module

echo "=== FeedFeature Init ==="

# Step 1 — read module state
echo ""
echo "--- Session state ---"
cat claude-progress.md

# Step 2 — read module rules
echo ""
echo "--- Module rules ---"
cat AGENTS.md

# Step 3 — generate Xcode project from yml
echo ""
echo "--- Generating Xcode project ---"
xcodegen generate

# Step 4 — check git status
echo ""
echo "--- Recent changes ---"
git log --oneline -5

echo ""
echo "=== Init complete ==="
echo "Next: read session-handoff.md for where to continue"