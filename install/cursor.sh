#!/bin/bash

# Exit on error
set -e

# Constants
INSTALL_DIR="/opt/cursor"
TEMP_DIR="$HOME/.local/share/cursor-installer/tmp"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/common.sh"

# Function to print status messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Function to cleanup temporary files
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Function to check if Cursor is already installed
check_existing_installation() {
    if [ -d "$INSTALL_DIR" ]; then
        warn "Cursor is already installed at $INSTALL_DIR"
        read -p "Do you want to reinstall? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Installation cancelled"
            exit 0
        fi
        log "Proceeding with reinstallation..."
    fi
}

# Function to check required dependencies
check_dependencies() {
    log "Checking required dependencies..."
    local deps=("curl" "git" "unzip" "jq")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log "Installing missing dependencies: ${missing_deps[*]}"
        sudo apt update -y
        sudo apt install -y "${missing_deps[@]}"
    fi
}

# Function to display help message
show_help() {
    echo "Cursor Installer"
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -f, --force    Force reinstallation without confirmation"
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

# Main installation process
main() {
    # Set up cleanup trap
    trap cleanup EXIT

    # Check if running as root
    check_root

    # Check existing installation
    if [ "$FORCE" = false ] && check_installation; then
        warn "Cursor is already installed at $INSTALL_DIR"
        read -p "Do you want to reinstall? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Installation cancelled"
            exit 0
        fi
        log "Proceeding with reinstallation..."
    fi

    # Create temporary directory
    log "Creating temporary directory..."
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    # Get version and download URL from API
    log "Fetching latest version information..."
    local api_response
    local version
    local download_url
    api_response=$(curl -L "$API_URL" || error "Failed to fetch version information")
    version=$(echo "$api_response" | jq -r '.version' || error "Failed to parse version")
    download_url=$(echo "$api_response" | jq -r '.downloadUrl' || error "Failed to parse download URL")

    log "Downloading Cursor version $version..."
    curl -L "$download_url" -o cursor.appimage || error "Failed to download Cursor"

    # Install AppImage
    log "Installing Cursor..."
    sudo chmod +x cursor.appimage
    ./cursor.appimage --appimage-extract || error "Failed to extract AppImage"
    sudo rm -rf "$INSTALL_DIR" 2>/dev/null || true
    sudo mv squashfs-root "$INSTALL_DIR" || error "Failed to move installation files"

    # Save version
    echo "$version" | sudo tee "$INSTALL_DIR/version.txt" > /dev/null

    # Find and configure chrome-sandbox
    log "Configuring chrome-sandbox..."
    local sandbox_path
    sandbox_path=$(find "$INSTALL_DIR" -name "chrome-sandbox" 2>/dev/null)
    if [ -z "$sandbox_path" ]; then
        error "chrome-sandbox not found"
    fi
    sudo chown root:root "$sandbox_path"
    sudo chmod 4755 "$sandbox_path"

    # Install required system packages
    log "Installing system dependencies..."
    sudo apt install -y fuse3 libfuse2t64

    # Create desktop entry
    create_desktop_entry "$version"

    # Create symlink
    log "Creating symlink..."
    sudo ln -sf "$INSTALL_DIR/AppRun" "$SYMLINK"

    # Setup update service
    log "Setting up automatic updates..."
    setup_update_service

    log "Installation completed successfully!"
    log "You can now launch Cursor from your applications menu or by typing 'cursor' in the terminal"
}

# Run main installation process
main
