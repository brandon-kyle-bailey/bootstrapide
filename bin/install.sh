#!/usr/bin/env bash

set -e

REPO="git@github.com:brandon-kyle-bailey/bootstrapide.git"
INSTALL_DIR="$HOME/.local/bootstrapide"
BIN_DIR="$HOME/.local/bin"
BIN_LINK="$BIN_DIR/bootstrapide"

echo "==> Installing bootstrapide CLI tool"

# Ensure required directories exist
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# Clone or update repo
if [[ -d "$INSTALL_DIR/.git" ]]; then
  echo "Updating existing bootstrapide installation..."
  git -C "$INSTALL_DIR" pull
else
  echo "Cloning bootstrapide repository into $INSTALL_DIR..."
  git clone "$REPO" "$INSTALL_DIR"
fi

# Make sure main script is executable (adjust if your CLI entry point differs)
chmod +x "$INSTALL_DIR/bin/"*

# Create or update symlink for easy access
if [[ -L "$BIN_LINK" ]]; then
  echo "Updating symlink at $BIN_LINK"
  ln -sf "$INSTALL_DIR/bin/setup.sh" "$BIN_LINK"
elif [[ -e "$BIN_LINK" ]]; then
  echo "Warning: $BIN_LINK exists and is not a symlink. Please remove or rename it first."
else
  echo "Creating symlink at $BIN_LINK"
  ln -s "$INSTALL_DIR/bin/setup.sh" "$BIN_LINK"
fi

# Check if ~/.local/bin is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  # Detect shell profile file to update
  if [[ -f "$HOME/.bash_profile" ]]; then
    PROFILE="$HOME/.bash_profile"
  elif [[ -f "$HOME/.profile" ]]; then
    PROFILE="$HOME/.profile"
  else
    PROFILE="$HOME/.bash_profile" # default fallback
    touch "$PROFILE"
  fi

  # Append path update if not already present
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$PROFILE"; then
    echo '' >>"$PROFILE"
    echo '# Added by bootstrapide installer' >>"$PROFILE"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$PROFILE"
    echo "Updated PATH in $PROFILE"
    echo "Please run 'source $PROFILE' or restart your terminal to use 'bootstrapide' command."
  fi
else
  echo "~/.local/bin is already in your PATH."
fi

export PATH="$HOME/.local/bin:$PATH"

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
echo "Installation complete! You can now run the tool by typing:"

printf "\nbootstrapide\n"
