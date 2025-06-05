#!/bin/bash

# Exit on error
set -e

# Constants
INSTALL_DIR="/opt/cursor"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
SYMLINK="/usr/local/bin/cursor"
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
TEMP_DIR="$HOME/.local/share/cursor-installer/tmp"
INSTALLER_DIR="$HOME/.local/share/cursor-installer"
INSTALLER_BIN_DIR="$HOME/.local/bin"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Function to check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        error "Please do not run this script as root"
    fi
}

# Function to check if Cursor is installed
check_installation() {
    if [ ! -d "$INSTALL_DIR" ]; then
        warn "Cursor is not installed at $INSTALL_DIR"
        return 1
    fi
    return 0
}

# Function to check if cursor-installer is installed
check_installer_installation() {
    if [ ! -f "$INSTALLER_BIN_DIR/cursor-installer" ]; then
        return 1
    fi
    return 0
}

# Function to get current installed version
get_installed_version() {
    if [ -f "$INSTALL_DIR/version.txt" ]; then
        cat "$INSTALL_DIR/version.txt"
    else
        echo "0.0.0"
    fi
}

# Function to get latest version from API
get_latest_version() {
    local api_response
    api_response=$(curl -L "$API_URL" || error "Failed to fetch version information")
    echo "$api_response" | jq -r '.version' || error "Failed to parse version"
}

# Function to create desktop entry
create_desktop_entry() {
    local version=$1
    sudo bash -c "cat > $DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Cursor
Comment=AI-powered code editor
Exec=$INSTALL_DIR/AppRun
Icon=$INSTALL_DIR/usr/share/icons/hicolor/256x256/apps/cursor.png
Type=Application
Categories=TextEditor;Development;IDE;
StartupNotify=false
StartupWMClass=Cursor
MimeType=application/x-cursor-workspace;
Actions=new-empty-window;
Keywords=cursor;
Terminal=false

X-AppImage-Version=$version

[Desktop Action new-empty-window]
Name=New Empty Window
Name[de]=Neues leeres Fenster
Name[es]=Nueva ventana vacía
Name[fr]=Nouvelle fenêtre vide
Name[it]=Nuova finestra vuota
Name[ja]=新しい空のウィンドウ
Name[ko]=새 빈 창
Name[ru]=Новое пустое окно
Name[zh_CN]=新建空窗口
Name[zh_TW]=開新空視窗
Exec=cursor --new-window %F
Icon=co.anysphere.cursor
EOL
    chmod +x "$DESKTOP_FILE"
    update-desktop-database ~/.local/share/applications/
}

# Function to setup update service
setup_update_service() {
    local service_dir="$HOME/.config/systemd/user"
    mkdir -p "$service_dir"

    # Create service file
    cat > "$service_dir/cursor-update.service" <<EOL
[Unit]
Description=Cursor Update Service
After=network.target

[Service]
Type=oneshot
ExecStart=$HOME/.local/bin/cursor-update
EOL

    # Create timer file
    cat > "$service_dir/cursor-update.timer" <<EOL
[Unit]
Description=Daily Cursor Update Check

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOL

    # Reload systemd and enable service
    systemctl --user daemon-reload
    systemctl --user enable --now cursor-update.timer
}

# Function to cleanup temporary files
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Function to install cursor-installer
install_cursor_installer() {
    if check_installer_installation; then
        log "cursor-installer is already installed"
        return 0
    fi

    log "Installing cursor-installer..."

    # Create necessary directories
    mkdir -p "$INSTALLER_DIR"
    mkdir -p "$INSTALLER_BIN_DIR"

    # Copy installer files
    cp -r "$SCRIPT_DIR/../"* "$INSTALLER_DIR/"
    chmod +x "$INSTALLER_DIR/bin/cursor-installer"

    # Create symlink
    ln -sf "$INSTALLER_DIR/bin/cursor-installer" "$INSTALLER_BIN_DIR/cursor-installer"

    log "cursor-installer installed successfully!"
}

# Function to uninstall cursor-installer
uninstall_cursor_installer() {
    if ! check_installer_installation; then
        warn "cursor-installer is not installed"
        return 1
    fi

    log "Uninstalling cursor-installer..."

    # Remove symlink
    rm -f "$INSTALLER_BIN_DIR/cursor-installer"

    # Remove installation directory
    rm -rf "$INSTALLER_DIR"

    log "cursor-installer uninstalled successfully!"
}

# Function to check OS compatibility
check_os_compatibility() {
    if ! command -v apt >/dev/null; then
        error "Unsupported distribution (requires apt). Exiting."
    fi
}

# Function to install system dependencies
install_system_dependencies() {
    log "Installing system dependencies..."
    sudo apt update -y
    sudo apt install -y curl git unzip jq fuse3 libfuse2t64
}