setup_languages() {
  echo "==> Language Support Setup"

  local options=(
    "Go (golang)"
    "Rust"
    "Zig"
    "Python 3 (via pyenv)"
    "Java (OpenJDK)"
    "Lua"
    "Ruby"
    "PHP"
    "C/C++ (gcc, g++)"
  )

  echo "Available languages:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  echo
  read -p "Enter comma-separated numbers to install specific languages, or press Enter to install all: " input

  local selected_indices=()

  if [[ -z "$input" ]]; then
    for i in "${!options[@]}"; do
      selected_indices+=("$((i + 1))")
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
    "Go (golang)")
      if command -v go >/dev/null 2>&1; then
        echo "✅ Go already installed."
      else
        echo "Installing Go..."
        if [[ -d /usr/local/go ]]; then
          echo "Removing pre-existing golang installation"
          sudo rm -rf /usr/local/go
        fi

        curl -fL https://go.dev/dl/go1.24.4.linux-amd64.tar.gz -o go.tar.gz &&
          sudo tar -C /usr/local -xzf go.tar.gz

        # Ensure PATH is persisted
        if ! grep -q 'go/bin' "$HOME/.bash_profile"; then
          echo -e '\n# Golang environment' >>"$HOME/.bash_profile"
          echo 'export PATH=$PATH:/usr/local/go/bin' >>"$HOME/.bash_profile"
        fi

        export PATH=$PATH:/usr/local/go/bin
      fi
      ;;
    "Rust")
      if command -v rustc >/dev/null 2>&1; then
        echo "✅ Rust already installed."
      else
        echo "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Ensure PATH is persisted
        if ! grep -q 'cargo/bin' "$HOME/.bash_profile"; then
          echo -e '\n# Rust environment' >>"$HOME/.bash_profile"
          echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.bash_profile"
        fi

        export PATH="$HOME/.cargo/bin:$PATH"
      fi
      ;;
    "Zig")
      if command -v zig >/dev/null 2>&1; then
        echo "✅ Zig already installed."
      else
        echo "Installing Zig..."
        sudo apt-get update
        sudo apt-get install -y zig
      fi
      ;;
    "Python 3 (via pyenv)")
      if command -v pyenv >/dev/null 2>&1; then
        echo "✅ pyenv already installed."
      else
        echo "Installing pyenv..."
        sudo apt-get update
        sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
          libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev \
          xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git

        curl https://pyenv.run | bash

        # Ensure PATH and pyenv init are persisted
        if ! grep -q 'pyenv init' "$HOME/.bash_profile"; then
          echo -e '\n# pyenv setup' >>"$HOME/.bash_profile"
          echo 'export PYENV_ROOT="$HOME/.pyenv"' >>"$HOME/.bash_profile"
          echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>"$HOME/.bash_profile"
          echo 'eval "$(pyenv init --path)"' >>"$HOME/.bash_profile"
          echo 'eval "$(pyenv init -)"' >>"$HOME/.bash_profile"
        fi

        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
      fi

      latest_python=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
      if pyenv versions | grep -q "$latest_python"; then
        echo "✅ Python $latest_python already installed with pyenv."
      else
        echo "Installing Python $latest_python via pyenv..."
        pyenv install "$latest_python"
      fi

      pyenv global "$latest_python"
      echo "✅ Python $latest_python set as global default."
      ;;
    "Java (OpenJDK)")
      if command -v javac >/dev/null 2>&1; then
        echo "✅ Java already installed."
      else
        echo "Installing OpenJDK..."
        sudo apt-get update
        sudo apt-get install -y openjdk-17-jdk
      fi
      ;;
    "Lua")
      if command -v lua >/dev/null 2>&1; then
        echo "✅ Lua already installed."
      else
        echo "Installing Lua..."
        sudo apt-get update
        sudo apt-get install -y lua5.4
      fi
      ;;
    "Ruby")
      if command -v ruby >/dev/null 2>&1; then
        echo "✅ Ruby already installed."
      else
        echo "Installing Ruby..."
        sudo apt-get update
        sudo apt-get install -y ruby-full
      fi
      ;;
    "PHP")
      if command -v php >/dev/null 2>&1; then
        echo "✅ PHP already installed."
      else
        echo "Installing PHP..."
        sudo apt-get update
        sudo apt-get install -y php-cli php-common php-mbstring php-xml php-curl
      fi
      ;;
    "C/C++ (gcc, g++)")
      if command -v gcc >/dev/null 2>&1 && command -v g++ >/dev/null 2>&1; then
        echo "✅ C/C++ compilers already installed."
      else
        echo "Installing C/C++ toolchain..."
        sudo apt-get update
        sudo apt-get install -y build-essential
      fi
      ;;
    esac
  done

  echo "✅ Language setup complete."
}

darwin_setup_languages() {
  echo "==> Language Support Setup"

  local options=(
    "Go (golang)"
    "Rust"
    "Zig"
    "Python 3 (via pyenv)"
    "Java (OpenJDK)"
    "Lua"
    "Ruby"
    "PHP"
    "C/C++ (gcc, g++)"
  )

  echo "Available languages:"
  for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i + 1))" "${options[i]}"
  done

  echo
  read -p "Enter comma-separated numbers to install specific languages, or press Enter to install all: " input

  local selected_indices=()

  if [[ -z "$input" ]]; then
    for i in "${!options[@]}"; do
      selected_indices+=("$((i + 1))")
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
    "Go (golang)")
      if command -v go >/dev/null 2>&1; then
        echo "✅ Go already installed."
      else
        echo "Installing Go..."
        if [[ -d /usr/local/go ]]; then
          echo "Removing pre-existing golang installation"
          sudo rm -rf /usr/local/go
        fi

        curl -fL https://go.dev/dl/go1.24.4.linux-amd64.tar.gz -o go.tar.gz &&
          sudo tar -C /usr/local -xzf go.tar.gz

        # Ensure PATH is persisted
        if ! grep -q 'go/bin' "$HOME/.bash_profile"; then
          echo -e '\n# Golang environment' >>"$HOME/.bash_profile"
          echo 'export PATH=$PATH:/usr/local/go/bin' >>"$HOME/.bash_profile"
        fi

        export PATH=$PATH:/usr/local/go/bin
      fi
      ;;
    "Rust")
      if command -v rustc >/dev/null 2>&1; then
        echo "✅ Rust already installed."
      else
        echo "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Ensure PATH is persisted
        if ! grep -q 'cargo/bin' "$HOME/.bash_profile"; then
          echo -e '\n# Rust environment' >>"$HOME/.bash_profile"
          echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.bash_profile"
        fi

        export PATH="$HOME/.cargo/bin:$PATH"
      fi
      ;;
    "Zig")
      if command -v zig >/dev/null 2>&1; then
        echo "✅ Zig already installed."
      else
        echo "Installing Zig..."
        sudo apt-get update
        sudo apt-get install -y zig
      fi
      ;;
    "Python 3 (via pyenv)")
      if command -v pyenv >/dev/null 2>&1; then
        echo "✅ pyenv already installed."
      else
        echo "Installing pyenv..."
        sudo apt-get update
        sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
          libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev \
          xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git

        curl https://pyenv.run | bash

        # Ensure PATH and pyenv init are persisted
        if ! grep -q 'pyenv init' "$HOME/.bash_profile"; then
          echo -e '\n# pyenv setup' >>"$HOME/.bash_profile"
          echo 'export PYENV_ROOT="$HOME/.pyenv"' >>"$HOME/.bash_profile"
          echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>"$HOME/.bash_profile"
          echo 'eval "$(pyenv init --path)"' >>"$HOME/.bash_profile"
          echo 'eval "$(pyenv init -)"' >>"$HOME/.bash_profile"
        fi

        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
      fi

      latest_python=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
      if pyenv versions | grep -q "$latest_python"; then
        echo "✅ Python $latest_python already installed with pyenv."
      else
        echo "Installing Python $latest_python via pyenv..."
        pyenv install "$latest_python"
      fi

      pyenv global "$latest_python"
      echo "✅ Python $latest_python set as global default."
      ;;
    "Java (OpenJDK)")
      if command -v javac >/dev/null 2>&1; then
        echo "✅ Java already installed."
      else
        echo "Installing OpenJDK..."
        sudo apt-get update
        sudo apt-get install -y openjdk-17-jdk
      fi
      ;;
    "Lua")
      if command -v lua >/dev/null 2>&1; then
        echo "✅ Lua already installed."
      else
        echo "Installing Lua..."
        sudo apt-get update
        sudo apt-get install -y lua5.4
      fi
      ;;
    "Ruby")
      if command -v ruby >/dev/null 2>&1; then
        echo "✅ Ruby already installed."
      else
        echo "Installing Ruby..."
        sudo apt-get update
        sudo apt-get install -y ruby-full
      fi
      ;;
    "PHP")
      if command -v php >/dev/null 2>&1; then
        echo "✅ PHP already installed."
      else
        echo "Installing PHP..."
        sudo apt-get update
        sudo apt-get install -y php-cli php-common php-mbstring php-xml php-curl
      fi
      ;;
    "C/C++ (gcc, g++)")
      if command -v gcc >/dev/null 2>&1 && command -v g++ >/dev/null 2>&1; then
        echo "✅ C/C++ compilers already installed."
      else
        echo "Installing C/C++ toolchain..."
        sudo apt-get update
        sudo apt-get install -y build-essential
      fi
      ;;
    esac
  done

  echo "✅ Language setup complete."
}
