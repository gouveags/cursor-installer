#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# Give people a chance to retry running the installation
trap 'echo "cursor-installer installation failed! You can retry by running: source ~/.local/share/cursor-installer/install.sh"' ERR

# Check the distribution name and version and abort if incompatible
source ~/.local/share/cursor-installer/install/check-version.sh

# We have more Desktop control if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  # Install cursor
  echo "Installing cursor..."
  source ~/.local/share/cursor-installer/install/cursor.sh

  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Installing cursor..."
  source ~/.local/share/cursor-installer/install/cursor.sh
fi