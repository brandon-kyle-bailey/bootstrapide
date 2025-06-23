#!/usr/bin/env bash

# Detect OS and run platform-specific setup script

OS_TYPE="$(uname -s)"

# Resolve real path of the script, resolving any symlinks
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"

echo "Resolved script directory: $SCRIPT_DIR"

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
