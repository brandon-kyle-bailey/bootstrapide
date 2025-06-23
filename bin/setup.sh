#!/usr/bin/env bash

# Detect OS and run platform-specific setup script

OS_TYPE="$(uname -s)"

case "$OS_TYPE" in
Linux*)
  echo "Detected Linux OS."
  # Either source or exec linux script
  exec "$(dirname "$0")/linux.sh" "$@"
  ;;
Darwin*)
  echo "Detected macOS."
  exec "$(dirname "$0")/darwin.sh" "$@"
  ;;
*)
  echo "Unsupported OS: $OS_TYPE"
  exit 1
  ;;
esac
