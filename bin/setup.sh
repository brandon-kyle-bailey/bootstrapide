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

echo "
______             _       _                  ___________ _____ 
| ___ \           | |     | |                |_   _|  _  \  ___|
| |_/ / ___   ___ | |_ ___| |_ _ __ __ _ _ __  | | | | | | |__  
| ___ \/ _ \ / _ \| __/ __| __| '__/ _\` | '_ \ | | | | | |  __| 
| |_/ / (_) | (_) | |_\__ \ |_| | | (_| | |_) || |_| |/ /| |___ 
\____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/\___/|___/ \____/ 
                                        | |                     
                                        |_|                     

"

# === Handle --update flag ===
if [[ "$1" == "--update" ]]; then
  "$INSTALL_ROOT/update.sh"
  exit $?
fi

case "$OS_TYPE" in
Linux*)
  echo "Detected Linux OS."
  # Either source or exec linux script
  exec "$SCRIPT_DIR/linux.sh" "$@"
  ;;
Darwin*)
  echo "Detected macOS."
  exec "$SCRIPT_DIR/darwin.sh" "$@"
  ;;
*)
  echo "Unsupported OS: $OS_TYPE"
  exit 1
  ;;
esac
