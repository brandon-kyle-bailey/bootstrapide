setup_tmux() {
  local config_dir="$HOME/.config/tmux"
  local repo_url="git@github.com:brandon-kyle-bailey/tmuskrat.git"

  echo "==> Setting up tmux config..."

  if [[ -d "$config_dir" ]]; then
    echo "⚠️  A tmux config already exists at $config_dir"

    read -p "Do you want to back it up and replace it with your tmux config? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      backup_dir="$HOME/.config/tmux.backup.$(date +%s)"
      mv "$config_dir" "$backup_dir"
      echo "🗃️  Backed up existing config to $backup_dir"

      echo "🔄 Cloning tmuskrat config..."
      git clone "$repo_url" "$config_dir"
      echo "✅ tmux config installed."

      if pgrep tmux >/dev/null; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" && echo "🔁 tmux config reloaded."
      fi
    else
      echo "❌ Skipping tmux config setup."
    fi
  else
    echo "🔄 Cloning tmuskrat config..."
    git clone "$repo_url" "$config_dir"
    echo "✅ tmux config installed."
  fi
}

setup_lazyvim() {
  local config_dir="$HOME/.config/nvim"
  local repo_url="git@github.com:brandon-kyle-bailey/neobat.git"

  echo "==> Setting up Neovim config with LazyVim..."

  if [[ -d "$config_dir" ]]; then
    echo "⚠️  A Neovim config already exists at $config_dir"

    read -p "Do you want to back it up and replace it with your LazyVim config? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      backup_dir="$HOME/.config/nvim.backup.$(date +%s)"
      mv "$config_dir" "$backup_dir"
      echo "🗃️  Backed up existing config to $backup_dir"

      echo "🔄 Cloning neobat config..."
      git clone "$repo_url" "$config_dir"
      echo "✅ LazyVim config installed."

      nvim --headless "+Lazy! sync" +qa
    else
      echo "📦 Plugins installed."
      echo "❌ Skipping LazyVim setup."
    fi
  else
    echo "🔄 Cloning neobat config..."
    git clone "$repo_url" "$config_dir"
    echo "✅ LazyVim config installed."
  fi
}

setup_editor() {
  echo "==> Editor Setup"

  local options=(
    "Neovim + tmux (terminal combo)"
    "VSCode (Visual Studio Code)"
    "Cursor (modern web-based editor)"
    "nano (simple terminal editor)"
    "Skip editor setup"
  )

  echo "Available editors/setups:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  read -p "Select an editor to install [1-${#options[@]}]: " choice

  if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || ((choice < 1 || choice > ${#options[@]})); then
    echo "Invalid choice, skipping editor setup."
    return
  fi

  local selected="${options[$((choice - 1))]}"
  echo "Selected: $selected"

  if [[ "$selected" == "Skip editor setup" ]]; then
    echo "Skipping editor setup."
    return
  fi

  if [[ "$selected" == "Neovim + tmux (terminal combo)" ]]; then
    if command -v nvim >/dev/null 2>&1; then
      echo "✅ Neovim already installed."
    else
      echo "Installing Neovim..."
      curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o nvim.tar.gz &&
        tar -xzf nvim.tar.gz &&
        sudo mv nvim-linux-x86_64 /opt/nvim &&
        sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim &&
        rm nvim.tar.gz
    fi

    if command -v tmux >/dev/null 2>&1; then
      echo "✅ tmux already installed."
    else
      echo "Installing tmux..."
      sudo apt update
      sudo apt install -y tmux
      if ! grep -Fxq '/usr/bin/tmux new-session -A -s default' "$HOME/.bash_profile"; then
        echo '/usr/bin/tmux new-session -A -s default' >>"$HOME/.bash_profile"
      fi
    fi

    setup_lazyvim
    setup_tmux

    echo "✅ Neovim + tmux setup complete."

  elif [[ "$selected" == "VSCode (Visual Studio Code)" ]]; then
    if command -v code >/dev/null 2>&1; then
      echo "✅ VSCode already installed."
    else
      echo "Installing VSCode..."

      local vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
      local tmpdeb
      tmpdeb=$(mktemp --suffix=.deb)

      echo "Downloading latest VSCode .deb..."
      curl -L "$vscode_url" -o "$tmpdeb"

      echo "Installing..."
      sudo dpkg -i "$tmpdeb" || sudo apt-get install -f -y
      rm "$tmpdeb"

      echo "✅ VSCode installed successfully."
    fi

    echo "✅ VSCode setup complete."

  elif [[ "$selected" == "Cursor (modern web-based editor)" ]]; then
    if command -v cursor >/dev/null 2>&1; then
      echo "✅ Cursor already installed."
    else
      echo "Installing Cursor AppImage..."

      local cursor_url="https://downloads.cursor.com/production/979ba33804ac150108481c14e0b5cb970bda3266/linux/x64/Cursor-1.1.3-x86_64.AppImage"
      local tmpappimage
      tmpappimage=$(mktemp)

      curl -L "$cursor_url" -o "$tmpappimage"
      chmod +x "$tmpappimage"

      sudo mv "$tmpappimage" /usr/local/bin/cursor

      echo "✅ Cursor AppImage installed to /usr/local/bin/cursor"
    fi

  elif [[ "$selected" == "nano (simple terminal editor)" ]]; then
    if command -v nano >/dev/null 2>&1; then
      echo "✅ nano already installed."
    else
      echo "Installing nano..."
      sudo apt update
      sudo apt install -y nano
    fi

    echo "✅ nano setup complete."
  fi
}

darwin_setup_tmux() {
  local config_dir="$HOME/.config/tmux"
  local repo_url="git@github.com:brandon-kyle-bailey/tmuskrat.git"

  echo "==> Setting up tmux config..."

  if [[ -d "$config_dir" ]]; then
    echo "⚠️  A tmux config already exists at $config_dir"

    read -p "Do you want to back it up and replace it with your tmux config? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      backup_dir="$HOME/.config/tmux.backup.$(date +%s)"
      mv "$config_dir" "$backup_dir"
      echo "🗃️  Backed up existing config to $backup_dir"

      echo "🔄 Cloning tmuskrat config..."
      git clone "$repo_url" "$config_dir"
      echo "✅ tmux config installed."

      if pgrep tmux >/dev/null; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" && echo "🔁 tmux config reloaded."
      fi
    else
      echo "❌ Skipping tmux config setup."
    fi
  else
    echo "🔄 Cloning tmuskrat config..."
    git clone "$repo_url" "$config_dir"
    echo "✅ tmux config installed."
  fi
}

darwn_setup_lazyvim() {
  local config_dir="$HOME/.config/nvim"
  local repo_url="git@github.com:brandon-kyle-bailey/neobat.git"

  echo "==> Setting up Neovim config with LazyVim..."

  if [[ -d "$config_dir" ]]; then
    echo "⚠️  A Neovim config already exists at $config_dir"

    read -p "Do you want to back it up and replace it with your LazyVim config? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      backup_dir="$HOME/.config/nvim.backup.$(date +%s)"
      mv "$config_dir" "$backup_dir"
      echo "🗃️  Backed up existing config to $backup_dir"

      echo "🔄 Cloning neobat config..."
      git clone "$repo_url" "$config_dir"
      echo "✅ LazyVim config installed."

      nvim --headless "+Lazy! sync" +qa
    else
      echo "📦 Plugins installed."
      echo "❌ Skipping LazyVim setup."
    fi
  else
    echo "🔄 Cloning neobat config..."
    git clone "$repo_url" "$config_dir"
    echo "✅ LazyVim config installed."
  fi
}

darwin_setup_editor() {
  echo "==> Editor Setup"

  local options=(
    "Neovim + tmux (terminal combo)"
    "VSCode (Visual Studio Code)"
    "Cursor (modern web-based editor)"
    "nano (simple terminal editor)"
    "Skip editor setup"
  )

  echo "Available editors/setups:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  read -p "Select an editor to install [1-${#options[@]}]: " choice

  if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || ((choice < 1 || choice > ${#options[@]})); then
    echo "Invalid choice, skipping editor setup."
    return
  fi

  local selected="${options[$((choice - 1))]}"
  echo "Selected: $selected"

  if [[ "$selected" == "Skip editor setup" ]]; then
    echo "Skipping editor setup."
    return
  fi

  if [[ "$selected" == "Neovim + tmux (terminal combo)" ]]; then
    if command -v nvim >/dev/null 2>&1; then
      echo "✅ Neovim already installed."
    else
      echo "Installing Neovim..."
      curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o nvim.tar.gz &&
        tar -xzf nvim.tar.gz &&
        sudo mv nvim-linux-x86_64 /opt/nvim &&
        sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim &&
        rm nvim.tar.gz
    fi

    if command -v tmux >/dev/null 2>&1; then
      echo "✅ tmux already installed."
    else
      echo "Installing tmux..."
      sudo apt update
      sudo apt install -y tmux
      if ! grep -Fxq '/usr/bin/tmux new-session -A -s default' "$HOME/.bash_profile"; then
        echo '/usr/bin/tmux new-session -A -s default' >>"$HOME/.bash_profile"
      fi
    fi

    setup_lazyvim
    setup_tmux

    echo "✅ Neovim + tmux setup complete."

  elif [[ "$selected" == "VSCode (Visual Studio Code)" ]]; then
    if command -v code >/dev/null 2>&1; then
      echo "✅ VSCode already installed."
    else
      echo "Installing VSCode..."

      local vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
      local tmpdeb
      tmpdeb=$(mktemp --suffix=.deb)

      echo "Downloading latest VSCode .deb..."
      curl -L "$vscode_url" -o "$tmpdeb"

      echo "Installing..."
      sudo dpkg -i "$tmpdeb" || sudo apt-get install -f -y
      rm "$tmpdeb"

      echo "✅ VSCode installed successfully."
    fi

    echo "✅ VSCode setup complete."

  elif [[ "$selected" == "Cursor (modern web-based editor)" ]]; then
    if command -v cursor >/dev/null 2>&1; then
      echo "✅ Cursor already installed."
    else
      echo "Installing Cursor AppImage..."

      local cursor_url="https://downloads.cursor.com/production/979ba33804ac150108481c14e0b5cb970bda3266/linux/x64/Cursor-1.1.3-x86_64.AppImage"
      local tmpappimage
      tmpappimage=$(mktemp)

      curl -L "$cursor_url" -o "$tmpappimage"
      chmod +x "$tmpappimage"

      sudo mv "$tmpappimage" /usr/local/bin/cursor

      echo "✅ Cursor AppImage installed to /usr/local/bin/cursor"
    fi

  elif [[ "$selected" == "nano (simple terminal editor)" ]]; then
    if command -v nano >/dev/null 2>&1; then
      echo "✅ nano already installed."
    else
      echo "Installing nano..."
      sudo apt update
      sudo apt install -y nano
    fi

    echo "✅ nano setup complete."
  fi
}
