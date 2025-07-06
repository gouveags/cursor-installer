# Cursor Installer 🖱️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Linux](https://img.shields.io/badge/OS-Linux-blue.svg)](https://www.kernel.org)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2B-orange.svg)](https://ubuntu.com)
[![Debian](https://img.shields.io/badge/Debian-11%2B-red.svg)](https://debian.org)

> **No need to be frustrated anymore, cursor-installer is here to help!**

Transform your Linux system into a Cursor-powered development environment with this comprehensive installer. This tool provides automatic installation, updates, and management of the Cursor IDE - an AI-powered code editor that will revolutionize your coding experience.

## 📋 Table of Contents

- [Cursor Installer 🖱️](#cursor-installer-️)
  - [📋 Table of Contents](#-table-of-contents)
  - [✨ Features](#-features)
  - [🚀 Quick Start](#-quick-start)
    - [One-Line Installation](#one-line-installation)
    - [Manual Installation](#manual-installation)
    - [Branch-Specific Installation](#branch-specific-installation)
  - [📋 System Requirements](#-system-requirements)
  - [🎮 Usage](#-usage)
    - [Interactive Menu](#interactive-menu)
    - [Command Line Interface](#command-line-interface)
      - [Available Commands](#available-commands)
      - [Command Examples](#command-examples)
  - [🗂️ Project Structure](#️-project-structure)
  - [🔧 Installation Details](#-installation-details)
    - [What Gets Installed](#what-gets-installed)
    - [Installation Locations](#installation-locations)
  - [🔄 Update System](#-update-system)
    - [Automatic Updates](#automatic-updates)
    - [Manual Updates](#manual-updates)
  - [🗑️ Uninstallation](#️-uninstallation)
    - [Uninstall Cursor IDE](#uninstall-cursor-ide)
    - [Remove Auto-updater](#remove-auto-updater)
    - [Complete Removal](#complete-removal)
    - [Manual Cleanup](#manual-cleanup)
  - [🧪 Development \& Testing](#-development--testing)
    - [Advanced Test Runner](#advanced-test-runner)
      - [Test Commands](#test-commands)
      - [Test Environments](#test-environments)
      - [Test Options](#test-options)
      - [Test Examples](#test-examples)
    - [Docker Testing](#docker-testing)
    - [Test Infrastructure](#test-infrastructure)
    - [Continuous Integration](#continuous-integration)
    - [Development Workflow](#development-workflow)
    - [Contributing Guidelines](#contributing-guidelines)
  - [🔍 Troubleshooting](#-troubleshooting)
    - [Common Issues](#common-issues)
    - [Debug Information](#debug-information)
    - [Log Files](#log-files)
  - [📚 FAQ](#-faq)
  - [🤝 Contributing](#-contributing)
  - [📜 License](#-license)
  - [🙏 Acknowledgments](#-acknowledgments)
  - [🔗 Links](#-links)

## ✨ Features

- **🚀 One-line Installation**: Install with a single curl command
- **🔄 Automatic Updates**: Background updates via systemd service
- **📱 Desktop Integration**: Native Linux desktop entry and menu integration
- **🖥️ Multi-Distribution Support**: Works on Ubuntu 20.04+, Debian 11+, and derivatives
- **⚡ Lightning Fast**: Optimized installation and update process
- **🎯 Command Line Interface**: Full-featured CLI with comprehensive commands
- **🛠️ Easy Management**: Install, update, uninstall, and configure with simple commands
- **🔧 Comprehensive Help**: Built-in help system and detailed documentation
- **🧪 Tested**: Comprehensive testing infrastructure with Docker

## 🚀 Quick Start

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/gouveags/cursor-installer.git
cd cursor-installer
./install.sh
```

### Branch-Specific Installation

Install from a specific branch (useful for testing development versions):

```bash
# Install from develop branch
export BRANCH_REF=develop
curl -fsSL https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh | bash

# Install from a specific feature branch
export BRANCH_REF=feature/my-feature
curl -fsSL https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh | bash
```

**Note**: The `BRANCH_REF` environment variable allows you to install cursor-installer from any branch in the repository. This is particularly useful for:
- Testing development versions
- Contributing to the project
- Trying experimental features

## 📋 System Requirements

- **Operating System**: Ubuntu 20.04+ or Debian 11+
- **Architecture**: x86_64 (64-bit)
- **Dependencies**: curl, jq, systemd (for automatic updates)
- **Permissions**: sudo access required for system installation

## 🎮 Usage

### Interactive Menu

Run without arguments to access the interactive menu:

```bash
cursor-installer
```

### Command Line Interface

The `cursor-installer` command provides a comprehensive CLI interface:

```bash
cursor-installer [COMMAND]
```

#### Available Commands

| Command | Description |
|---------|-------------|
| `install` | Install or update Cursor IDE |
| `uninstall` | Uninstall Cursor IDE completely |
| `remove-updater` | Remove the automatic updater service |
| `update` | Check for and install updates |
| `check` | Check for available updates (without installing) |
| `version` | Show currently installed version |
| `latest` | Show latest available version |
| `status` | Show detailed installation status |
| `help` | Show comprehensive help information |

#### Command Examples

```bash
# Install or update Cursor
cursor-installer install

# Check current installation status
cursor-installer status

# Check for updates without installing
cursor-installer check

# Show installed version
cursor-installer version

# Show latest available version
cursor-installer latest

# Update to latest version
cursor-installer update

# Show help
cursor-installer help
```

## 🗂️ Project Structure

```
cursor-installer/
├── 📜 boot.sh                          # 🚀 Main curl installation target
├── 📜 install.sh                       # 🔧 Local installation script
├── 📁 bin/
│   └── 📜 cursor-installer            # 🎯 Main command-line interface
├── 📁 scripts/
│   ├── 📜 common.sh                   # 🔄 Shared functions and utilities
│   ├── 📜 cursor-update               # ⚡ Update service script
│   └── 📜 uninstall.sh                # 🗑️ Uninstaller script
├── 📁 test/                           # 🧪 Testing infrastructure
│   ├── 📜 docker-compose.yml          # 🐳 Test orchestration
│   ├── 📜 run-tests.sh                # 🎮 Test runner
│   └── 📁 test-scripts/               # 📝 Test implementations
├── 📁 .github/workflows/              # 🤖 CI/CD pipeline
│   └── 📜 test.yml                    # ✅ Automated testing
├── 📜 README.md                       # 📚 This documentation
└── 📜 LICENSE                         # ⚖️ MIT License
```

## 🔧 Installation Details

### What Gets Installed

- **Cursor IDE**: Latest stable version from official source
- **Desktop Entry**: Native Linux application menu integration
- **System Link**: `/usr/local/bin/cursor` symlink for command access
- **Auto-updater**: Systemd service for automatic updates (optional)
- **Management Tools**: Complete CLI interface for all operations

### Installation Locations

- **Main Installation**: `/opt/cursor/`
- **Desktop Entry**: `~/.local/share/applications/cursor.desktop`
- **System Link**: `/usr/local/bin/cursor`
- **Auto-updater**: `~/.config/systemd/user/cursor-update.{service,timer}`
- **Temporary Files**: `~/.local/share/cursor-installer/`

## 🔄 Update System

### Automatic Updates

The installer sets up a systemd service that automatically checks for and installs updates:

```bash
# Check updater status
systemctl --user status cursor-update.timer

# Enable automatic updates
systemctl --user enable --now cursor-update.timer

# Disable automatic updates
systemctl --user disable --now cursor-update.timer
```

### Manual Updates

```bash
# Check for updates
cursor-installer check

# Install updates
cursor-installer update

# Or use the direct update command
cursor-installer install
```

## 🗑️ Uninstallation

### Uninstall Cursor IDE

Remove Cursor IDE while keeping the installer:

```bash
cursor-installer uninstall
```

### Remove Auto-updater

Remove the automatic update service:

```bash
cursor-installer remove-updater
```

### Complete Removal

To completely remove everything including the installer:

```bash
# First uninstall Cursor
cursor-installer uninstall

# Remove auto-updater
cursor-installer remove-updater

# Remove the installer itself
sudo rm -rf /opt/cursor-installer
sudo rm -f /usr/local/bin/cursor-installer

# Clean up any remaining files
rm -rf ~/.local/share/cursor-installer
```

### Manual Cleanup

If you need to manually clean up:

```bash
# Remove Cursor installation
sudo rm -rf /opt/cursor

# Remove desktop entry
rm -f ~/.local/share/applications/cursor.desktop

# Remove system link
sudo rm -f /usr/local/bin/cursor

# Remove auto-updater
systemctl --user disable --now cursor-update.timer cursor-update.service
rm -f ~/.config/systemd/user/cursor-update.{service,timer}
systemctl --user daemon-reload

# Remove temporary files
rm -rf ~/.local/share/cursor-installer
```

## 🧪 Development & Testing

### Advanced Test Runner

The project includes a sophisticated test runner with comprehensive functionality:

```bash
cd test
./run-tests.sh [OPTIONS] [COMMAND] [ENVIRONMENT]
```

#### Test Commands

| Command | Description |
|---------|-------------|
| `build` | Build all test containers |
| `test [ENV]` | Run full test suite (default: all environments) |
| `quick-test [ENV]` | Run quick diagnostic tests |
| `shell [ENV]` | Open interactive shell in test environment |
| `clean` | Clean up test containers and volumes |
| `logs [ENV]` | Show logs from test environment |

#### Test Environments

| Environment | Description |
|-------------|-------------|
| `ubuntu-22` | Ubuntu 22.04 LTS |
| `ubuntu-20` | Ubuntu 20.04 LTS |
| `debian-12` | Debian 12 |
| `all` | All environments (default) |

#### Test Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-v, --verbose` | Verbose output |
| `--no-cache` | Build without cache |
| `--pull` | Pull latest base images |

#### Test Examples

```bash
# Build all test containers
./run-tests.sh build

# Run all tests across all environments
./run-tests.sh test

# Run tests on specific environment
./run-tests.sh test ubuntu-22

# Run quick diagnostic tests
./run-tests.sh quick-test ubuntu-22

# Open interactive shell for debugging
./run-tests.sh shell debian-12

# View logs from test environment
./run-tests.sh logs ubuntu-20

# Clean up everything
./run-tests.sh clean

# Build with options
./run-tests.sh --no-cache --pull build
```

### Docker Testing

Direct Docker testing (alternative to test runner):

```bash
# Test on Ubuntu 22.04
docker-compose -f test/docker-compose.yml run ubuntu-22

# Test on Ubuntu 20.04
docker-compose -f test/docker-compose.yml run ubuntu-20

# Test on Debian 12
docker-compose -f test/docker-compose.yml run debian-12
```

### Test Infrastructure

The testing infrastructure includes:

- **Multi-distribution Support**: Ubuntu 22.04, Ubuntu 20.04, Debian 12
- **Containerized Testing**: Isolated test environments with Docker
- **Comprehensive Test Suite**: 6 different test scenarios:
  1. System Dependencies Check
  2. Directory Structure Validation
  3. Script Syntax Verification
  4. Curl-based Installation Test
  5. Local Installation Test
  6. Dry-run Mode Test
- **Quick Diagnostic Tests**: Fast environment validation
- **Interactive Debugging**: Shell access for troubleshooting
- **Automated CI/CD**: GitHub Actions with daily scheduled tests
- **Syntax Validation**: Automatic shell script syntax checking
- **Integration Testing**: Full installation workflow validation

### Continuous Integration

The project uses GitHub Actions for automated testing:

- **Syntax Check**: Validates all shell scripts
- **Multi-Distribution Testing**: Tests on Ubuntu 22.04, 20.04, and Debian 12
- **Integration Testing**: Tests curl-based installation method
- **Structure Validation**: Ensures all required files are present
- **Documentation Testing**: Validates README completeness
- **Daily Scheduled Tests**: Runs tests daily at 2 AM UTC
- **Pull Request Testing**: Automatic testing on all PRs

### Development Workflow

For contributors working on the project:

1. **Fork and Clone**:
   ```bash
   git clone https://github.com/yourusername/cursor-installer.git
   cd cursor-installer
   ```

2. **Create Feature Branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

3. **Test Your Changes**:
   ```bash
   # Build test environments
   cd test
   ./run-tests.sh build

   # Run quick tests for rapid feedback
   ./run-tests.sh quick-test ubuntu-22

   # Run full test suite
   ./run-tests.sh test

   # Test specific environment
   ./run-tests.sh test debian-12

   # Debug interactively if needed
   ./run-tests.sh shell ubuntu-22
   ```

4. **Test Branch-Specific Installation**:
   ```bash
   # Test your branch before submitting PR
   export BRANCH_REF=feature/my-feature
   curl -fsSL https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh | bash
   ```

5. **Submit Pull Request**:
   - Ensure all tests pass
   - Include description of changes
   - Update documentation if needed

### Contributing Guidelines

- **Code Style**: Follow existing bash script conventions
- **Testing**: All changes must pass the test suite
- **Documentation**: Update README for new features
- **Compatibility**: Ensure compatibility with all supported distributions
- **Security**: Be mindful of security implications in installation scripts

## 🔍 Troubleshooting

### Common Issues

**Permission Denied**
```bash
# Ensure you have sudo access
sudo -v
```

**Network Issues**
```bash
# Check your internet connection
curl -I https://cursor.com
```

**Desktop Entry Not Appearing**
```bash
# Update desktop database
update-desktop-database ~/.local/share/applications/
```

**Auto-updater Not Working**
```bash
# Check systemd user services
systemctl --user status cursor-update.timer
systemctl --user enable --now cursor-update.timer
```

### Debug Information

Get detailed information about your installation:

```bash
cursor-installer status
```

### Log Files

Check logs for troubleshooting:

```bash
# Installation logs
journalctl --user -u cursor-update.service

# System logs
sudo journalctl | grep cursor
```

## 📚 FAQ

**Q: Does this work on other Linux distributions?**
A: Currently tested on Ubuntu 20.04+, Debian 11+, and derivatives. Other distributions may work but are not officially supported.

**Q: Can I install multiple versions of Cursor?**
A: No, this installer manages a single system-wide installation. For multiple versions, use the official AppImage directly.

**Q: Is this official software from Cursor?**
A: No, this is a community-created installer. Cursor IDE itself is official software from Cursor.

**Q: How do I update the installer itself?**
A: Re-run the installation command to get the latest version of the installer.

**Q: Can I disable automatic updates?**
A: Yes, use `cursor-installer remove-updater` to disable automatic updates.

**Q: Where are my Cursor settings stored?**
A: Cursor settings are stored in `~/.config/cursor/` and are not affected by this installer.

## 🤝 Contributing

Contributions are welcome! Please feel free to:

- Report bugs and issues
- Suggest new features
- Submit pull requests
- Improve documentation
- Add support for more distributions

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Cursor](https://www.cursor.com/)** - For creating an amazing AI-powered code editor
- **[Omakub](https://omakub.org/)** - For inspiration on Linux setup automation
- **[watzon/cursor-linux-installer](https://github.com/watzon/cursor-linux-installer)** - For initial ideas on Linux Cursor installation

## 🔗 Links

- **Project Repository**: https://github.com/gouveags/cursor-installer
- **Issue Tracker**: https://github.com/gouveags/cursor-installer/issues
- **Cursor IDE**: https://cursor.com
- **Documentation**: https://github.com/gouveags/cursor-installer/blob/main/README.md

---

**Made with ❤️ for the Linux community**
