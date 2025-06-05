#!/bin/bash

# Exit on error
set -e

# Constants
INSTALL_DIR="/opt/cursor"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
SYMLINK="/usr/local/bin/cursor"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Function to check if Cursor is installed
check_installation() {
    if [ ! -d "$INSTALL_DIR" ]; then
        warn "Cursor is not installed at $INSTALL_DIR"
        return 1
    fi
    return 0
}

# Function to display help message
show_help() {
    echo "Cursor Uninstaller"
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -f, --force    Force uninstallation without confirmation"
    echo
    exit 0
}

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Main uninstallation process
main() {
    # Check if running as root
    check_root

    # Check if Cursor is installed
    if ! check_installation; then
        exit 0
    fi

    # Ask for confirmation unless force flag is set
    if [ "$FORCE" = false ]; then
        read -rp "Are you sure you want to uninstall Cursor? (y/N) " ans
        if [[ "${ans,,}" != "y" ]]; then
            log "Uninstallation cancelled"
            exit 0
        fi
    fi

    log "Starting Cursor uninstallation..."

    # Remove desktop file
    if [ -f "$DESKTOP_FILE" ]; then
        log "Removing desktop entry..."
        rm -f "$DESKTOP_FILE"
        update-desktop-database ~/.local/share/applications/
    fi

    # Remove symlink
    if [ -L "$SYMLINK" ]; then
        log "Removing symlink..."
        sudo rm -f "$SYMLINK"
    fi

    # Remove installation directory
    if [ -d "$INSTALL_DIR" ]; then
        log "Removing Cursor installation..."
        sudo rm -rf "$INSTALL_DIR"
    fi

    # Remove temporary directory
    if [ -d "$HOME/.local/share/cursor-installer" ]; then
        log "Removing temporary files..."
        rm -rf "$HOME/.local/share/cursor-installer"
    fi

    # Remove update service
    if [ -f "$HOME/.config/systemd/user/cursor-update.service" ]; then
        log "Removing update service..."
        systemctl --user disable --now cursor-update.timer cursor-update.service
        rm -f "$HOME/.config/systemd/user/cursor-update."{service,timer}
        systemctl --user daemon-reload
    fi

    log "Uninstallation completed successfully!"
}

# Run main uninstallation process
main

