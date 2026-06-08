#!/bin/bash
# FeedDemo Workspace — Initialization Script
# Use this for cross-module work or fresh project setup
# For single-module work, use the module's own init.sh

echo "=== FeedDemo Workspace Init ==="

# Step 1 — read workspace state
echo ""
echo "--- Session state ---"
cat claude-progress.md

# Step 2 — read workspace rules
echo ""
echo "--- Workspace rules ---"
cat AGENTS.md

# Step 3 — read architecture
echo ""
echo "--- Architecture ---"
cat ARCHITECTURE.md

# Step 4 — generate all module projects
echo ""
echo "--- Generating all projects ---"
./generate_all.sh

# Step 5 — check git status
echo ""
echo "--- Recent changes ---"
git log --oneline -5

echo ""
echo "=== Init complete ==="
echo "For single-module work go to the module directory and run ./init.sh there"
echo "Next: read session-handoff.md for where to continue"