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

# Resolve the absolute path to the directory of the current script, following symlinks
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import modules
source "$SCRIPT_DIR/src/modules/git.sh"
source "$SCRIPT_DIR/src/modules/nvm.sh"
source "$SCRIPT_DIR/src/modules/terminal.sh"
source "$SCRIPT_DIR/src/modules/docker.sh"
source "$SCRIPT_DIR/src/modules/editor.sh"
source "$SCRIPT_DIR/src/modules/lang.sh"
source "$SCRIPT_DIR/src/modules/tooling.sh"
source "$SCRIPT_DIR/src/modules/utility.sh"

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
