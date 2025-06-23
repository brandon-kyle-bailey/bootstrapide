setup_docker() {
  echo "==> Docker Setup"

  if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker is already installed. Skipping installation."
    return
  fi

  echo "Installing Docker CE..."

  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt remove -y "$pkg"; done

  # Update package info and install dependencies
  sudo apt update
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  # Add Docker’s official GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Set up the stable repository
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  # Install Docker Engine packages
  sudo apt-update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Post-install steps (optional)
  echo "==> Adding current user to docker group (may require logout/login)..."
  if ! getent group docker >/dev/null; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker "$USER"

  echo "==> Enabling docker service start on login..."
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service

  echo "✅ Docker installation complete."
  echo "You might need to log out and back in for docker group changes to take effect."
}
