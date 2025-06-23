setup_git() {
  echo "==> Updating package lists..."
  sudo apt update -y

  echo "==> Installing Git..."
  sudo apt install -y git

  echo "==> Installing GitHub CLI (gh)..."
  sudo apt install -y gh

  echo "==> Configuring Git..."
  read -p -r "Enter your Git name (e.g., John Doe): " git_name
  read -p -r "Enter your GitHub email: " git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  echo "Git configured with:"
  git config --global --list

  echo "==> Generating a new SSH key..."
  ssh_key_path="$HOME/.ssh/id_ed25519"
  if [[ -f "$ssh_key_path" ]]; then
    echo "SSH key already exists at $ssh_key_path. Skipping generation."
  else
    ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key_path"
  fi

  echo "==> Starting ssh-agent and adding your SSH key..."
  eval "$(ssh-agent -s)"
  ssh-add "$ssh_key_path"

  echo "==> Copying your public SSH key to the clipboard..."
  if command -v xclip &>/dev/null; then
    xclip -sel clip <"${ssh_key_path}.pub"
    echo "Your SSH public key has been copied to the clipboard."
  else
    echo "xclip is not installed. Please copy the key below manually:"
    echo "----------------------------------------"
    cat "${ssh_key_path}.pub"
    echo "----------------------------------------"
  fi

  echo "==> Please add your SSH key to GitHub:"
  echo "👉 https://github.com/settings/keys"
  read -p "Press [Enter] once your key has been added..."
  echo "==> Logging in via GitHub CLI..."
  gh auth login

  echo "✅ Git and GitHub CLI setup complete!"
}
