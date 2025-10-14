#!/bin/bash

# A simple script to add, commit with a generic message, and push changes.
echo "🚀 Syncing with GitHub..."

# Add all changes
git add .

# Commit with a default message
git commit -m "chore: update notes and projects"

# Push to the remote repository
git push

echo "✅ Sync complete."
