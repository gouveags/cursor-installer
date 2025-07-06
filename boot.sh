#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALLER_DIR="$HOME/.local/share/cursor-installer"
INSTALLER_BIN_DIR="$HOME/.local/bin"
REPO_URL="https://github.com/gouveags/cursor-installer.git"
BRANCH_REF="${BRANCH_REF:-main}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Show ASCII banner
show_banner() {
    clear
    cat << 'EOF'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@%*%@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@%*++#@%%%%@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@#++++**#@@%%%##%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@#++++++**##@@@%%%%###%@@@@@@@@@@@@@@
@@@@@@@@@@%*+++++++****##%%%%%%#######%%@@@@@@@@@@
@@@@@@@@@@#*-:......................:::+@@@@@@@@@@
@@@@@@@@@@####*=::..............:::::-+%@@@@@@@@@@
@@@@@@@@@@#######*+::........:::::::-+%%@@@@@@@@@@
@@@@@@@@@@###########+::::::::::::::*%%%@@@@@@@@@@
@@@@@@@@@@############%#+:::::::::-#%%%%@@@@@@@@@@
@@@@@@@@@@####%%#######**-:::::::-#%%%%%@@@@@@@@@@
@@@@@@@@@@####%%###******-::::::-#@@%%%%@@@@@@@@@@
@@@@@@@@@@######*********-:::---+*#%@@%%@@@@@@@@@@
@@@@@@@@@@##**********+++------==++++*%%@@@@@@@@@@
@@@@@@@@@@#+=++++++++++++-----==------=*@@@@@@@@@@
@@@@@@@@@@@@@%+=====++++=----------=#@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@+=======-------=%@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@%*====----+%@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@#+-*%@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@   ____                          @@@@@@@@@
@@@@@@@@  / ___|   _ _ __ ___  ___  _ __ @@@@@@@@@
@@@@@@@@ | |  | | | | '__/ __|/ _ \| '__|@@@@@@@@@
@@@@@@@@ | |__| |_| | |  \__ \ (_) | |   @@@@@@@@@
@@@@@@@@  \____\__,_|_|  |___/\___/|_|   @@@@@@@@@
@@@@@@@@                                 @@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EOF
    echo
    print_header "=> No need to be frustrated anymore, cursor-installer is here to help!"
    print_header "=> Turn your Linux system into a Cursor-powered development environment!"
    print_header "=> This installer will download, install, and configure Cursor IDE"
    print_header "=> with automatic updates and desktop integration."
    echo
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root"
        exit 1
    fi
}

# Check OS compatibility
check_os() {
    if ! command -v apt >/dev/null 2>&1; then
        print_error "This installer requires a Debian/Ubuntu-based system with apt package manager"
        exit 1
    fi

    # Check if system is supported
    if ! grep -qE "(ubuntu|debian)" /etc/os-release 2>/dev/null; then
        print_warning "This installer is designed for Ubuntu/Debian systems"
        print_warning "It may work on other apt-based distributions but is not tested"
        echo
        echo -n "Do you want to continue anyway? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled by user"
            exit 0
        fi
    fi
}

# Install required dependencies
install_dependencies() {
    print_status "Installing required dependencies..."

    # Update package list
    if ! sudo apt update >/dev/null 2>&1; then
        print_error "Failed to update package list"
        exit 1
    fi

    # Install git if not present
    if ! command -v git >/dev/null 2>&1; then
        print_status "Installing git..."
        if ! sudo apt install -y git >/dev/null 2>&1; then
            print_error "Failed to install git"
            exit 1
        fi
    fi

    # Install curl if not present
    if ! command -v curl >/dev/null 2>&1; then
        print_status "Installing curl..."
        if ! sudo apt install -y curl >/dev/null 2>&1; then
            print_error "Failed to install curl"
            exit 1
        fi
    fi
}

# Clone or update the installer repository
setup_installer() {
    print_status "Setting up cursor-installer..."

    # Remove old installation if it exists
    if [ -d "$INSTALLER_DIR" ]; then
        print_status "Removing previous installation..."
        rm -rf "$INSTALLER_DIR"
    fi

    # Create directories
    mkdir -p "$INSTALLER_DIR"
    mkdir -p "$INSTALLER_BIN_DIR"

    # Clone the repository
    print_status "Downloading cursor-installer..."
    if ! git clone "$REPO_URL" "$INSTALLER_DIR" >/dev/null 2>&1; then
        print_error "Failed to clone cursor-installer repository"
        exit 1
    fi

    # Checkout specific branch if specified
    if [[ "$BRANCH_REF" != "main" ]]; then
        print_status "Checking out branch: $BRANCH_REF"
        cd "$INSTALLER_DIR"
        if ! git fetch origin "$BRANCH_REF" >/dev/null 2>&1; then
            print_error "Failed to fetch branch: $BRANCH_REF"
            exit 1
        fi
        if ! git checkout "$BRANCH_REF" >/dev/null 2>&1; then
            print_error "Failed to checkout branch: $BRANCH_REF"
            exit 1
        fi
        cd - >/dev/null
    fi

    # Make scripts executable
    chmod +x "$INSTALLER_DIR/install.sh"
    chmod +x "$INSTALLER_DIR/bin/cursor-installer"

    # Create symlink for easy access
    if [ ! -L "$INSTALLER_BIN_DIR/cursor-installer" ]; then
        ln -sf "$INSTALLER_DIR/bin/cursor-installer" "$INSTALLER_BIN_DIR/cursor-installer"
    fi

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$INSTALLER_BIN_DIR:"* ]]; then
        # Add to bashrc
        if [ -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi

        # Add to zshrc if it exists
        if [ -f "$HOME/.zshrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        fi

        # Export for current session
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

# Run the main installer
run_installer() {
    print_status "Starting cursor-installer setup..."
    echo

    # Navigate to installer directory and run the main installer
    cd "$INSTALLER_DIR"
    if ! source ./install.sh; then
        print_error "Installation failed"
        exit 1
    fi
}

# Show completion message
show_completion() {
    echo
    print_header "╔══════════════════════════════════════════════════════════╗"
    print_header "║                                                          ║"
    print_header "║  🎉 Cursor Installer has been successfully installed!    ║"
    print_header "║                                                          ║"
    print_header "║  You can now use:                                        ║"
    print_header "║  • cursor-installer - Interactive management tool       ║"
    print_header "║  • cursor - Launch Cursor IDE                           ║"
    print_header "║                                                          ║"
    print_header "║  The installer includes automatic updates via systemd.  ║"
    print_header "║                                                          ║"
    print_header "║  To get started:                                         ║"
    print_header "║  1. Restart your terminal or run: source ~/.bashrc      ║"
    print_header "║  2. Run: cursor-installer                                ║"
    print_header "║                                                          ║"
    print_header "╚══════════════════════════════════════════════════════════╝"
    echo
    print_status "Installation completed successfully!"
    print_status "Repository: https://github.com/gouveags/cursor-installer"
}

# Main installation function
main() {
    # Show banner
    show_banner

    # Ask for user confirmation
    print_status "This installer will:"
    echo "  • Install system dependencies (git, curl)"
    echo "  • Download and set up cursor-installer"
    echo "  • Install Cursor IDE with desktop integration"
    echo "  • Configure automatic updates"
    echo
    echo -n "Press ENTER to continue or Ctrl+C to cancel..."
    read -r
    echo

    # Perform checks
    check_root
    check_os

    # Install dependencies
    install_dependencies

    # Setup installer
    setup_installer

    # Run the main installer
    run_installer

    # Show completion message
    show_completion
}

# Handle interruption gracefully
trap 'echo; print_error "Installation interrupted by user"; exit 1' INT TERM

# Run main function
main