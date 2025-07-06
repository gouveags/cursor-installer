#!/bin/bash

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# Give people a chance to retry running the installation
trap 'error "cursor-installer installation failed! You can retry by running: source ~/.local/share/cursor-installer/install.sh"' ERR

# Check OS compatibility
check_os_compatibility

# Install system dependencies
install_system_dependencies

# Install cursor-installer
install_cursor_installer

# We have more Desktop control if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    # Ensure computer doesn't go to sleep or lock while installing
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0

    # Install cursor
    log "Installing Cursor..."
    "$INSTALLER_BIN_DIR/cursor-installer"

    # Revert to normal idle and lock settings
    gsettings set org.gnome.desktop.screensaver lock-enabled true
    gsettings set org.gnome.desktop.session idle-delay 300
else
    log "Installing Cursor..."
    "$INSTALLER_BIN_DIR/cursor-installer"
fi