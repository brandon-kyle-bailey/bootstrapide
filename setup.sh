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

# Import modules
source "$(dirname "$0")/modules/git.sh"
source "$(dirname "$0")/modules/nvm.sh"
source "$(dirname "$0")/modules/terminal.sh"
source "$(dirname "$0")/modules/docker.sh"
source "$(dirname "$0")/modules/neovim.sh"
source "$(dirname "$0")/modules/editor.sh"
source "$(dirname "$0")/modules/lang.sh"

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
  echo "5) Neovim"
  echo "6) Editor"
  echo "7) Programming Languages"
  echo "9) All"
  echo "0) Exit"
  echo ""

  read -p "Enter your choice [1-3]: " choice

  case "$choice" in
  1)
    run_step "Setting up Git and GitHub CLI..." setup_git
    ;;
  2)
    run_step "Setting up NVM and Node.js..." setup_nvm
    ;;
  3)
    run_step "Setting up Terminal Emulator..." setup_terminal
    ;;
  4)
    run_step "Setting up Docker and Docker Compose..." setup_docker
    ;;
  5)
    run_step "Setting up Neovim..." setup_neovim
    ;;
  6)
    run_step "Setting up Editor..." setup_editor
    ;;
  7)
    run_step "Setting up Programming Languages..." setup_languages
    ;;
  9)
    run_step "Setting up Git and GitHub CLI..." setup_git
    run_step "Setting up NVM and Node.js..." setup_nvm
    run_step "Setting up Terminal Emulator..." setup_terminal
    run_step "Setting up Docker and Docker Compose..." setup_docker
    run_step "Setting up Neovim..." setup_neovim
    run_step "Setting up Editor..." setup_editor
    run_step "Setting up Programming Languages..." setup_languages
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

  echo ""
  echo "✅ Setup complete."
}

main
