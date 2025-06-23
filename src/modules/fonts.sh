setup_fonts() {
  echo "==> Installing Ubuntu Nerd Font"

  FONT_DIR="/usr/share/fonts/UbuntuNerdFont"
  FONT_ZIP="Ubuntu.zip"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Ubuntu.zip"

  # Check if font dir already exists with some files
  if [[ -d "$FONT_DIR" && $(find "$FONT_DIR" -type f | wc -l) -gt 0 ]]; then
    echo "✅ Ubuntu Nerd Font already installed in $FONT_DIR"
    return
  fi

  # Ensure unzip is installed
  if ! command -v unzip >/dev/null 2>&1; then
    echo "==> Installing unzip utility..."
    sudo apt update -y
    sudo apt install -y unzip
  fi

  # Create font directory
  sudo mkdir -p "$FONT_DIR"

  # Download font zip to /tmp and extract
  tmpdir=$(mktemp -d)
  echo "==> Downloading Nerd Font to $tmpdir/$FONT_ZIP"
  curl -L -o "$tmpdir/$FONT_ZIP" "$FONT_URL"

  echo "==> Extracting fonts to $FONT_DIR"
  sudo unzip -o "$tmpdir/$FONT_ZIP" -d "$FONT_DIR"

  # Clean up
  rm -rf "$tmpdir"

  echo "==> Refreshing font cache..."
  sudo fc-cache -fv

  echo "✅ Ubuntu Nerd Font installed successfully."
}

darwin_setup_fonts() {
  echo "==> Installing Ubuntu Nerd Font"

  FONT_DIR="/usr/share/fonts/UbuntuNerdFont"
  FONT_ZIP="Ubuntu.zip"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Ubuntu.zip"

  # Check if font dir already exists with some files
  if [[ -d "$FONT_DIR" && $(find "$FONT_DIR" -type f | wc -l) -gt 0 ]]; then
    echo "✅ Ubuntu Nerd Font already installed in $FONT_DIR"
    return
  fi

  # Ensure unzip is installed
  if ! command -v unzip >/dev/null 2>&1; then
    echo "==> Installing unzip utility..."
    sudo apt update -y
    sudo apt install -y unzip
  fi

  # Create font directory
  sudo mkdir -p "$FONT_DIR"

  # Download font zip to /tmp and extract
  tmpdir=$(mktemp -d)
  echo "==> Downloading Nerd Font to $tmpdir/$FONT_ZIP"
  curl -L -o "$tmpdir/$FONT_ZIP" "$FONT_URL"

  echo "==> Extracting fonts to $FONT_DIR"
  sudo unzip -o "$tmpdir/$FONT_ZIP" -d "$FONT_DIR"

  # Clean up
  rm -rf "$tmpdir"

  echo "==> Refreshing font cache..."
  sudo fc-cache -fv

  echo "✅ Ubuntu Nerd Font installed successfully."
}
