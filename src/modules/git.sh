setup_git() {
  echo "==> Git and GitHub CLI Setup"

  # Update and install git
  if command -v git >/dev/null 2>&1; then
    echo "✅ Git is already installed."
  else
    echo "==> Installing Git..."
    sudo apt update -y
    sudo apt install -y git
  fi

  # Install GitHub CLI
  if command -v gh >/dev/null 2>&1; then
    echo "✅ GitHub CLI (gh) is already installed."
  else
    echo "==> Installing GitHub CLI (gh)..."
    sudo apt install -y gh
  fi

  # Git config
  existing_name=$(git config --global user.name || echo "")
  existing_email=$(git config --global user.email || echo "")

  if [[ -n "$existing_name" && -n "$existing_email" ]]; then
    echo "✅ Git is already configured:"
    git config --global --list | grep -E 'user.name|user.email'
  else
    echo "==> Configuring Git..."
    read -p "Enter your Git name (e.g., John Doe): " git_name
    read -p "Enter your GitHub email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "✅ Git configured:"
    git config --global --list | grep -E 'user.name|user.email'
  fi

  # SSH key setup
  ssh_key_path="$HOME/.ssh/id_ed25519"
  if [[ -f "$ssh_key_path" ]]; then
    echo "✅ SSH key already exists at $ssh_key_path"
  else
    echo "==> Generating a new SSH key..."
    read -p "Confirm your GitHub email for SSH key (press Enter to use $existing_email): " git_email_input
    [[ -z "$git_email_input" ]] && git_email_input="$existing_email"
    ssh-keygen -t ed25519 -C "$git_email_input" -f "$ssh_key_path"
  fi

  # Start SSH agent and add key
  echo "==> Starting ssh-agent and adding your key..."
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add -l | grep -q "$ssh_key_path" || ssh-add "$ssh_key_path"

  # Copy SSH key to clipboard
  echo "==> Copying SSH public key to clipboard..."
  if command -v xclip &>/dev/null; then
    xclip -sel clip <"${ssh_key_path}.pub"
    echo "✅ SSH key copied to clipboard."
  else
    echo "⚠️ xclip not installed. Please manually copy this key:"
    echo "----------------------------------------"
    cat "${ssh_key_path}.pub"
    echo "----------------------------------------"
  fi

  # Prompt user to add key on GitHub
  echo "==> Please add your SSH key to GitHub:"
  echo "👉 https://github.com/settings/keys"
  read -p "Press [Enter] once your key has been added..."

  # GitHub CLI login
  if gh auth status >/dev/null 2>&1; then
    echo "✅ GitHub CLI already authenticated."
  else
    echo "==> Logging in via GitHub CLI..."
    gh auth login
  fi

  echo "✅ Git and GitHub CLI setup complete!"
}

darwn_setup_git() {
  echo "==> Git and GitHub CLI Setup"

  # Update and install git
  if command -v git >/dev/null 2>&1; then
    echo "✅ Git is already installed."
  else
    echo "==> Installing Git..."
    sudo apt update -y
    sudo apt install -y git
  fi

  # Install GitHub CLI
  if command -v gh >/dev/null 2>&1; then
    echo "✅ GitHub CLI (gh) is already installed."
  else
    echo "==> Installing GitHub CLI (gh)..."
    sudo apt install -y gh
  fi

  # Git config
  existing_name=$(git config --global user.name || echo "")
  existing_email=$(git config --global user.email || echo "")

  if [[ -n "$existing_name" && -n "$existing_email" ]]; then
    echo "✅ Git is already configured:"
    git config --global --list | grep -E 'user.name|user.email'
  else
    echo "==> Configuring Git..."
    read -p "Enter your Git name (e.g., John Doe): " git_name
    read -p "Enter your GitHub email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "✅ Git configured:"
    git config --global --list | grep -E 'user.name|user.email'
  fi

  # SSH key setup
  ssh_key_path="$HOME/.ssh/id_ed25519"
  if [[ -f "$ssh_key_path" ]]; then
    echo "✅ SSH key already exists at $ssh_key_path"
  else
    echo "==> Generating a new SSH key..."
    read -p "Confirm your GitHub email for SSH key (press Enter to use $existing_email): " git_email_input
    [[ -z "$git_email_input" ]] && git_email_input="$existing_email"
    ssh-keygen -t ed25519 -C "$git_email_input" -f "$ssh_key_path"
  fi

  # Start SSH agent and add key
  echo "==> Starting ssh-agent and adding your key..."
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add -l | grep -q "$ssh_key_path" || ssh-add "$ssh_key_path"

  # Copy SSH key to clipboard
  echo "==> Copying SSH public key to clipboard..."
  if command -v xclip &>/dev/null; then
    xclip -sel clip <"${ssh_key_path}.pub"
    echo "✅ SSH key copied to clipboard."
  else
    echo "⚠️ xclip not installed. Please manually copy this key:"
    echo "----------------------------------------"
    cat "${ssh_key_path}.pub"
    echo "----------------------------------------"
  fi

  # Prompt user to add key on GitHub
  echo "==> Please add your SSH key to GitHub:"
  echo "👉 https://github.com/settings/keys"
  read -p "Press [Enter] once your key has been added..."

  # GitHub CLI login
  if gh auth status >/dev/null 2>&1; then
    echo "✅ GitHub CLI already authenticated."
  else
    echo "==> Logging in via GitHub CLI..."
    gh auth login
  fi

  echo "✅ Git and GitHub CLI setup complete!"
}
