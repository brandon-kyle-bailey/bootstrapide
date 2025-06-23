setup_tooling() {
  echo "==> Tooling Setup"

  local options=(
    "AWS CLI"
    "kubectl"
    "Terraform"
    "Pulumi"
    "Helm"
    "CloudFormation CLI"
    "DBeaver Community"
    "none (skip tooling installation)"
  )

  echo "Available CLI tools to install:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  read -p "Enter comma-separated numbers to install specific tools, or press Enter to install all: " input

  local selected_indices=()

  if [[ -z "$input" ]]; then
    # Default: install all except 'none'
    for i in "${!options[@]}"; do
      if [[ "${options[i]}" != "none (skip tooling installation)" ]]; then
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
    "AWS CLI")
      if command -v aws >/dev/null 2>&1; then
        echo "✅ AWS CLI already installed."
      else
        echo "Installing AWS CLI..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
        unzip -q /tmp/awscliv2.zip -d /tmp
        sudo /tmp/aws/install
        rm -rf /tmp/aws /tmp/awscliv2.zip
      fi
      ;;
    "kubectl")
      if command -v kubectl >/dev/null 2>&1; then
        echo "✅ kubectl already installed."
      else
        echo "Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

        echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

        if [ $? -eq 0 ]; then
          sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
          echo "✅ kubectl installed successfully."
        else
          echo "❌ kubectl checksum verification failed. Aborting installation."
          rm kubectl kubectl.sha256
          return 1
        fi

        rm kubectl kubectl.sha256
      fi
      ;;
    "Terraform")
      if command -v terraform >/dev/null 2>&1; then
        echo "✅ Terraform already installed."
      else
        echo "Installing Terraform..."
        sudo apt-get update
        sudo apt-get install -y gnupg software-properties-common wget

        wget -O- https://apt.releases.hashicorp.com/gpg |
          gpg --dearmor |
          sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

        gpg --no-default-keyring \
          --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
          --fingerprint

        UBUNTU_CODENAME=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" |
          sudo tee /etc/apt/sources.list.d/hashicorp.list

        sudo apt-get update
        sudo apt-get install -y terraform

        echo "Enabling Terraform autocomplete..."
        terraform -install-autocomplete
      fi
      ;;
    "Pulumi")
      if command -v pulumi >/dev/null 2>&1; then
        echo "✅ Pulumi already installed."
      else
        echo "Installing Pulumi..."
        curl -fsSL https://get.pulumi.com | sh

        # Add Pulumi to PATH for current session
        export PATH="$HOME/.pulumi/bin:$PATH"

        # Persist PATH addition if not already present
        if ! grep -q '.pulumi/bin' "$HOME/.bash_profile"; then
          echo -e '\n# Pulumi CLI' >>"$HOME/.bash_profile"
          echo 'export PATH="$HOME/.pulumi/bin:$PATH"' >>"$HOME/.bash_profile"
        fi
      fi
      ;;
    "Helm")
      if command -v helm >/dev/null 2>&1; then
        echo "✅ Helm already installed."
      else
        echo "Installing Helm..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      fi
      ;;
    "CloudFormation CLI")
      if command -v cfn >/dev/null 2>&1; then
        echo "✅ CloudFormation CLI already installed."
      else
        echo "Installing CloudFormation CLI and plugins..."

        # Ensure pip3 is available
        if ! command -v pip3 >/dev/null 2>&1; then
          echo "pip3 not found. Installing..."
          sudo apt-get update
          sudo apt-get install -y python3-pip
        fi

        pip3 install --user \
          cloudformation-cli \
          cloudformation-cli-java-plugin \
          cloudformation-cli-go-plugin \
          cloudformation-cli-python-plugin \
          cloudformation-cli-typescript-plugin

        # Add ~/.local/bin to PATH if needed
        if ! grep -q '.local/bin' "$HOME/.bash_profile"; then
          echo -e '\n# CloudFormation CLI' >>"$HOME/.bash_profile"
          echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bash_profile"
        fi

        export PATH="$HOME/.local/bin:$PATH"
      fi
      ;;
    "DBeaver Community")
      if command -v dbeaver >/dev/null 2>&1; then
        echo "✅ DBeaver is already installed."
        return
      fi
      echo "Installing DBeaver Community Edition..."

      sudo apt-get install -y software-properties-common
      sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
      sudo apt-get update -y
      sudo apt-get install -y dbeaver-ce

      echo "✅ DBeaver Community Edition installation complete."
      ;;
    "none (skip tooling installation)")
      echo "Skipping tooling installation."
      return
      ;;
    *)
      echo "❌ Unknown tooling option: $choice"
      ;;
    esac
  done

  echo "✅ Tooling setup complete."
}
