#!/bin/bash

PYTHON_VERSION="3"
PRE_COMMIT_VERSION="3.6.0"
HOOK_NAME="check-yaml"  # Specify the name of the hook to enable or disable

# Check if enable option is set in git config
ENABLE_HOOK=$(git config --get hooks.${HOOK_NAME}.enable)
if [ -z "$ENABLE_HOOK" ]; then
    ENABLE_HOOK=true  # Set a default value if not configured
fi

# Function to install Python if needed
install_python() {
    os=$(uname -s)
    case $os in
    Linux)
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y python$PYTHON_VERSION
        elif command -v dnf &> /dev/null; then
            sudo dnf update
            sudo dnf install -y python$PYTHON_VERSION
        elif command -v pacman &> /dev/null; then
            sudo pacman -Syu
            sudo pacman -S python$PYTHON_VERSION
        else
            echo "Unsupported package manager"
            exit 1
        fi
        ;;
    Darwin)
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install python$PYTHON_VERSION
        ;;
    *)
        echo "Unsupported or unrecognized operating system"
        exit 1
        ;;
    esac
}

# Function to install the script and execute
install_and_execute() {
    curl -fsSL https://raw.githubusercontent.com/LawRider/gitleaks-pre-commit-hook/hook.sh | sh
}

# Install Python if not installed
if ! command -v python$PYTHON_VERSION &> /dev/null; then
    install_python
fi

# Check if the specific hook should be enabled
if [ "$ENABLE_HOOK" == "true" ]; then
    # Download pre-commit and configure hooks
    curl -O https://github.com/pre-commit/pre-commit/releases/download/v$PRE_COMMIT_VERSION/pre-commit-$PRE_COMMIT_VERSION.pyz

    cat >> ./.pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: $HOOK_NAME
EOF

    echo ".pre-commit*" >> .gitignore
    echo "pre-commit*" >> .gitignore

    # Install pre-commit
    python$PYTHON_VERSION pre-commit-$PRE_COMMIT_VERSION.pyz
    python$PYTHON_VERSION pre-commit-$PRE_COMMIT_VERSION.pyz autoupdate
    python$PYTHON_VERSION pre-commit-$PRE_COMMIT_VERSION.pyz install

    # Clean up
    rm -rf pre-commit-$PRE_COMMIT_VERSION.pyz
    echo "Hook '$HOOK_NAME' is enabled."
else
    echo "Hook '$HOOK_NAME' is disabled."
fi

# Clean up the script if installed via "curl ... | sh"
if [ -n "$BASH_SOURCE" ] && [ "$BASH_SOURCE" == "$0" ]; then
    rm -f "$0"
fi
