#!/usr/bin/env bash

set -e

INSTALL_DIR="${HOME}/.local/bootstrapide"

echo "🔄 Updating bootstrapide from $INSTALL_DIR"

# Ensure directory exists
if [[ ! -d "$INSTALL_DIR" ]]; then
  echo "❌ Install directory not found at $INSTALL_DIR"
  echo "Make sure you've installed bootstrapide first."
  exit 1
fi

cd "$INSTALL_DIR"

# Check if it's a git repo
if [[ ! -d .git ]]; then
  echo "❌ $INSTALL_DIR is not a Git repository."
  exit 1
fi

# Pull latest changes
git pull origin main || git pull origin master

# Ensure bin scripts are executable
find "$INSTALL_DIR/bin" -type f -exec chmod +x {} \;

echo "✅ bootstrapide has been updated!"
