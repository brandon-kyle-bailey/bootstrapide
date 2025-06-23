setup_terminal() {
  echo "==> Terminal Emulator Setup"

  # List popular terminal emulators
  local options=(
    "kitty"
    "alacritty"
    "tilix"
    "gnome-terminal"
    "xfce4-terminal"
    "none (skip installation)"
  )

  echo "Available terminal emulators to install:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  read -p "Select terminal emulator to install [1-${#options[@]}]: " choice

  # Validate input
  if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || ((choice < 1 || choice > ${#options[@]})); then
    echo "Invalid choice, skipping terminal installation."
    return
  fi

  local selected="${options[$((choice - 1))]}"

  if [[ "$selected" == "none (skip installation)" ]]; then
    echo "Skipping terminal emulator installation."
    return
  fi

  # Check if terminal is installed
  if command -v "$selected" >/dev/null 2>&1; then
    echo "✅ $selected is already installed. Skipping installation."
    return
  fi

  echo "Selected terminal emulator: $selected"

  echo "Installing $selected..."
  sudo apt update
  sudo apt install -y "$selected"

  # Alacritty config setup
  if [[ "$selected" == "alacritty" ]]; then
    if [[ -d "$HOME/.config/alacritty" ]]; then
      echo "✅ Alacritty config already exists. Skipping clone."
    else
      echo "Cloning Alacritty config..."
      git clone git@github.com:brandon-kyle-bailey/alacritty.git "$HOME/.config/alacritty"
    fi
  fi

  echo "✅ Terminal emulator setup complete."
}
