setup_neovim() {
  echo "==> Neovim Setup"

  if command -v nvim >/dev/null 2>&1; then
    echo "✅ Neovim is already installed. Skipping installation."
    return
  fi
}
