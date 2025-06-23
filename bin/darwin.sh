#!/usr/bin/env bash

# Set flags
DRY_RUN=false

# Parse args
for arg in "$@"; do
  case $arg in
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  esac
done

# Resolve real path of the script, resolving any symlinks
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"

# The project root directory is one level up from the script directory (which is "bin")
BASE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Resolved script directory: $SCRIPT_DIR"
echo "Project base directory: $BASE_DIR"

# Now source modules from BASE_DIR/src/modules/
source "$BASE_DIR/src/modules/git.sh"
source "$BASE_DIR/src/modules/nvm.sh"
source "$BASE_DIR/src/modules/terminal.sh"
source "$BASE_DIR/src/modules/docker.sh"
source "$BASE_DIR/src/modules/editor.sh"
source "$BASE_DIR/src/modules/lang.sh"
source "$BASE_DIR/src/modules/tooling.sh"
source "$BASE_DIR/src/modules/utility.sh"

# Function wrappers with dry-run support
run_step() {
  local description="$1"
  local func="$2"

  echo ""
  echo "==> $description"

  if $DRY_RUN; then
    echo "⚠️  Dry run: would run '$func'"
  else
    $func
  fi
}

# Interactive prompt
main() {
  echo "=== Developer Environment Setup ==="
  echo "Select which components you want to install:"
  echo "1) Git & GitHub CLI"
  echo "2) NVM & Node.js (latest stable)"
  echo "3) Terminal Emulator"
  echo "4) Docker & Docker Compose"
  echo "6) Editor (Neovim + tmux, etc.)"
  echo "7) Programming Languages (Golang, etc.)"
  echo "8) Tooling (aws-cli, etc.)"
  echo "9) Utiltities (bitwarden-cli, lazygit, etc.)"
  echo "10) All"
  echo "0) Exit"
  echo ""

  read -p "Enter your choice [0-10]: " choice

  case "$choice" in
  1)
    run_step "Setting up Git and GitHub CLI..." darwin_setup_git
    ;;
  2)
    run_step "Setting up NVM and Node.js..." darwin_setup_nvm
    ;;
  3)
    run_step "Setting up Terminal Emulator..." darwin_setup_terminal
    ;;
  4)
    run_step "Setting up Docker and Docker Compose..." darwin_setup_docker
    ;;
  6)
    run_step "Setting up Editor..." darwin_setup_editor
    ;;
  7)
    run_step "Setting up Programming Languages..." darwin_setup_languages
    ;;
  8)
    run_step "Setting up Tooling..." darwin_setup_tooling
    ;;
  9)
    run_step "Setting up Utilities..." darwin_setup_utilities
    ;;
  10)
    run_step "Setting up Git and GitHub CLI..." darwin_setup_git
    run_step "Setting up NVM and Node.js..." darwin_setup_nvm
    run_step "Setting up Terminal Emulator..." darwin_setup_terminal
    run_step "Setting up Docker and Docker Compose..." darwin_setup_docker
    run_step "Setting up Editor..." darwin_setup_editor
    run_step "Setting up Programming Languages..." darwin_setup_languages
    run_step "Setting up Tooling..." darwin_setup_tooling
    run_step "Setting up Utilities..." darwin_setup_utilities
    ;;
  0)
    echo "Exiting."
    exit 0
    ;;
  *)
    echo "❌ Invalid choice. Exiting."
    exit 1
    ;;
  esac

  printf "\n✅ Setup complete.\n"
}

main
