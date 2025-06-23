setup_nvm() {
  echo "==> Checking for NVM..."

  if [[ -d "$HOME/.nvm" ]]; then
    echo "NVM is already installed."
  else
    NVM_LATEST=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest |
      grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    echo "NVM_LATEST: $NVM_LATEST"

    echo "==> Installing NVM $NVM_LATEST..."
    export PROFILE="$HOME/.bash_profile"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST}/install.sh" | bash
  fi

  # Ensure NVM loads in future sessions
  if ! grep -q 'NVM_DIR' "$HOME/.bash_profile"; then
    echo "==> Adding NVM initialization to ~/.bash_profile..."
    cat <<'EOF' >>"$HOME/.bash_profile"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
  fi

  # Load NVM into current shell
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  echo "==> Node.js version selection"
  read -p -r "Enter Node.js version to install (leave blank for latest stable): " node_version

  if [[ -z "$node_version" ]]; then
    node_version="node"
    echo "No version specified, defaulting to latest stable."
  fi

  echo "==> Installing Node.js version: $node_version"
  nvm install "$node_version"

  echo "==> Setting Node.js $node_version as the default version"
  nvm alias default "$node_version"
  nvm use default

  echo "✅ Node.js $(node -v) installed and set as default."
  echo "🔁 Run 'source ~/.bash_profile' or restart your terminal to activate nvm in new sessions."
}
