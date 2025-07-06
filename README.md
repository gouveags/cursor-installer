# Cursor Installer 🖱️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Linux](https://img.shields.io/badge/OS-Linux-blue.svg)](https://www.kernel.org)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2B-orange.svg)](https://ubuntu.com)
[![Debian](https://img.shields.io/badge/Debian-11%2B-red.svg)](https://debian.org)

> **No need to be frustrated anymore, cursor-installer is here to help!**

Transform your Linux system into a Cursor-powered development environment with this comprehensive installer. This tool provides automatic installation, updates, and management of the Cursor IDE - an AI-powered code editor that will revolutionize your coding experience.

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

```bash
export BRANCH_REF=develop
curl -fsSL https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh | bash
```

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

### Local Testing

Run the comprehensive test suite:

```bash
cd test
./run-tests.sh build    # Build test environments
./run-tests.sh test     # Run all tests
./run-tests.sh clean    # Clean up test environments
```

### Docker Testing

Test on different distributions:

```bash
# Test on Ubuntu 22.04
docker-compose -f test/docker-compose.yml run ubuntu22

# Test on Ubuntu 20.04
docker-compose -f test/docker-compose.yml run ubuntu20

# Test on Debian 12
docker-compose -f test/docker-compose.yml run debian12
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

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
