#!/usr/bin/env bash

set -euo pipefail

# Define color functions using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "${CYAN}${BOLD}Battery Notifier Installer${RESET}"
echo "${YELLOW}This script will install dependencies, copy voice files, and set up the notifier.${RESET}"
echo ""

# Ask for confirmation
read -rp "$(echo -e "${YELLOW}Do you want to continue with the installation? (y/N): ${RESET}")" confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "${RED}Installation aborted by user.${RESET}"
  exit 1
fi

echo ""
echo "${CYAN}Installing battery notifier and voice alerts...${RESET}"
echo ""

# Function to detect and install packages
install_deps() {
  echo "${CYAN}Checking and installing dependencies...${RESET}"

  if command -v pacman >/dev/null 2>&1; then
    echo "${GREEN}Detected pacman. Installing dependencies...${RESET}"
    sudo pacman -Sy --noconfirm acpi mpv libnotify
  elif command -v apt >/dev/null 2>&1; then
    echo "${GREEN}Detected apt. Installing dependencies...${RESET}"
    sudo apt update && sudo apt install -y acpi mpv libnotify-bin
  elif command -v dnf >/dev/null 2>&1; then
    echo "${GREEN}Detected dnf. Installing dependencies...${RESET}"
    sudo dnf install -y acpi mpv libnotify
  elif command -v zypper >/dev/null 2>&1; then
    echo "${GREEN}Detected zypper. Installing dependencies...${RESET}"
    sudo zypper install -y acpi mpv libnotify-tools
  else
    echo "${RED}Unsupported package manager. Please install acpi, mpv, and libnotify manually.${RESET}"
  fi
  echo ""
}

install_deps

# Create destination directory
DEST="$HOME/.local/share/battery-notifier"
mkdir -p "$DEST"

# Copy entire voices directory
cp -ruv voices "$DEST"

# Make script executable and copy to local bin
install -Dm755 bin/battery-notifier "$HOME/.local/bin/battery-notifier"

echo ""
echo "${GREEN}✔ Audio files installed to:${RESET} $DEST"
echo "${GREEN}✔ Script installed to:${RESET} $HOME/.local/bin/battery-notifier"

echo ""
echo "${YELLOW}To auto-start on boot:${RESET}"
echo "  - ${CYAN}A pre-made .desktop file is already included in this project.${RESET}"
echo "  - Just copy it to the autostart folder like this:"
echo "    ${GREEN}mkdir -p ~/.config/autostart${RESET}"
echo "    ${GREEN}cp battery-notifier.desktop ~/.config/autostart${RESET}"
echo ""
echo "  - This will auto-run the script on login using this command:"
echo "    ${CYAN}setsid -f \$HOME/.local/bin/battery-notifier >/dev/null 2>&1 &${RESET}"
echo ""
echo "  - ${CYAN}If you're using a window manager (WM) and not a full desktop environment (DE),${RESET}"
echo "    add this command to your WM's autostart file (like bspwmrc, i3 config, etc):"
echo "    ${GREEN}setsid -f \$HOME/.local/bin/battery-notifier >/dev/null 2>&1 &${RESET}"

echo ""
echo "${CYAN}${BOLD}Installation complete!${RESET} 🎉"
