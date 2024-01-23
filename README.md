# Pre-commit Installation Script Manual

## Overview

This script automates the installation of Python, pre-commit, and a specific pre-commit hook (`check-yaml` by default). The script can be configured to enable or disable the specified hook using `git config`. Additionally, it provides the option to be installed via the "curl ... | sh" method.

## Usage

### 1. Install Script

To install the script using the "curl ... | sh" method, run the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/LawRider/gitleaks-pre-commit-hook/hook.sh | sh
```
### 2. Configuration
The script can be configured using git config to enable or disable the specified pre-commit hook.

Enable the Hook:
```bash
git config --global hooks.check-yaml.enable true
```
Disable the Hook:
```bash
git config --global hooks.check-yaml.enable false
```
### 3. Execution
The script will automatically detect whether Python is installed. If not, it will install Python based on your operating system.

If the specified pre-commit hook is enabled, the script will download pre-commit and configure the specified hook in the .pre-commit-config.yaml file. It will then install pre-commit and clean up temporary files.

### 4. Cleanup (if installed via "curl ... | sh")
If you've installed the script via "curl ... | sh" and want to remove the script after installation, the script will clean up itself. You don't need to manually remove it.

### Notes
Make sure you have internet access during the installation process.
The script is designed to be self-contained and cleans up after installation.

### Examples
# Install the script using "curl ... | sh"
```bash
curl -fsSL https://raw.githubusercontent.com/LawRider/gitleaks-pre-commit-hook/hook.sh | sh
```

# Enable the specified pre-commit hook
```bash
git config --global hooks.check-yaml.enable true
```

# Execute the script (it will install Python, pre-commit, and configure the specified hook)
# The script will also clean up temporary files after installation
```bash
./hook.sh
```

# Disable the specified pre-commit hook
```bash
git config --global hooks.check-yaml.enable false
```
