#!/usr/bin/env bash

# Detect OS and run platform-specific setup script

OS_TYPE="$(uname -s)"

# Resolve the absolute path to the directory of the current script, following symlinks
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo SCRIPT_DIR: "$SCRIPT_DIR"

case "$OS_TYPE" in
Linux*)
  echo "Detected Linux OS."
  # Either source or exec linux script
  exec "$SCRIPT_DIR/bin/linux.sh" "$@"
  ;;
Darwin*)
  echo "Detected macOS."
  exec "$SCRIPT_DIR/bin/darwin.sh" "$@"
  ;;
*)
  echo "Unsupported OS: $OS_TYPE"
  exit 1
  ;;
esac
