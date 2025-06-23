setup_utilities() {
  echo "==> Utilities Setup"

  local options=(
    "Bitwarden CLI"
    "htop"
    "jq"
    "fzf (fuzzy finder)"
    "ripgrep (rg)"
    "bat (cat with wings)"
    "exa (ls replacement)"
    "lazygit"
    "tldr (simplified man pages)"
    "zoxide (smarter cd)"
    "none (skip utilities installation)"
  )

  echo "Available utilities to install:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  echo
  read -p "Enter comma-separated numbers to install specific utilities, or press Enter to install all: " input

  local selected_indices=()

  if [[ -z "$input" ]]; then
    for i in "${!options[@]}"; do
      if [[ "${options[i]}" != "none (skip utilities installation)" ]]; then
        selected_indices+=("$((i + 1))")
      fi
    done
  else
    IFS=',' read -ra selected_indices <<<"$input"
  fi

  for index in "${selected_indices[@]}"; do
    index=$(echo "$index" | xargs)
    if ! [[ "$index" =~ ^[0-9]+$ ]] || ((index < 1 || index > ${#options[@]})); then
      echo "❌ Invalid selection: $index"
      continue
    fi

    local choice="${options[$((index - 1))]}"

    case "$choice" in
    "Bitwarden CLI")
      if command -v bw >/dev/null 2>&1; then
        echo "✅ Bitwarden CLI already installed."
      else
        echo "Installing Bitwarden CLI..."
        curl -L "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o /tmp/bw.zip
        unzip -q /tmp/bw.zip -d /tmp/bw
        sudo install /tmp/bw/bw /usr/local/bin/bw
        rm -rf /tmp/bw /tmp/bw.zip
      fi
      ;;
    "htop")
      sudo apt-get install -y htop
      ;;
    "jq")
      sudo apt-get install -y jq
      ;;
    "fzf (fuzzy finder)")
      if command -v fzf >/dev/null 2>&1; then
        echo "✅ fzf already installed."
      else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
      fi
      ;;
    "ripgrep (rg)")
      sudo apt-get install -y ripgrep
      ;;
    "bat (cat with wings)")
      if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
        sudo apt-get install -y bat
        echo "alias bat='batcat'" >>"$HOME/.bash_profile"
      else
        sudo apt-get install -y bat
      fi
      ;;
    "exa (ls replacement)")
      sudo apt-get install -y exa
      ;;
    "lazygit")
      if command -v lazygit >/dev/null 2>&1; then
        echo "✅ lazygit already installed."
      else
        echo "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep tag_name | cut -d '"' -f 4)
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
      fi
      ;;
    "tldr (simplified man pages)")
      if command -v tldr >/dev/null 2>&1; then
        echo "✅ tldr already installed."
      else
        sudo npm install -g tldr
        tldr --update
      fi
      ;;
    "zoxide (smarter cd)")
      if command -v zoxide >/dev/null 2>&1; then
        echo "✅ zoxide already installed."
      else
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        if ! grep -q 'zoxide init' "$HOME/.bash_profile"; then
          echo -e '\n# zoxide init' >>"$HOME/.bash_profile"
          echo 'eval "$(zoxide init bash)"' >>"$HOME/.bash_profile"
        fi
        eval "$(zoxide init bash)"
      fi
      ;;
    "none (skip utilities installation)")
      echo "Skipping utilities installation."
      return
      ;;
    *)
      echo "❌ Unknown utility option: $choice"
      ;;
    esac
  done

  echo "✅ Utilities setup complete."
}
