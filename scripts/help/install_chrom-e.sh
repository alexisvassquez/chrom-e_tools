#!/bin/bash

# Chrom-E Installer
# Creates a global command called `chrom-e` pointing to chrom-e_help.sh

TARGET="/usr/local/bin/chrom-e"
SOURCE="$(pwd)/chrom-e_help.sh"

echo "💾 Installing Chrom-E Toolkit command..."

# Check for root if needed
if [[ $EUID -ne 0 ]]; then
    echo "🛑 This script needs superuser permissions to create a symlink in /usr/local/bin"
    echo "📜 Re-running with sudo..."
    exec sudo bash "$0"
fi

# Create the symlink
chmod +x "$SOURCE"

if [[ -e "$TARGET" ]]; then
    echo "🔁 Existing 'chrom-e' command found. Replacing..."
    rm -f "$TARGET"
fi

ln -s "$SOURCE" "$TARGET"

# Confirm success
echo -e "✅ Chrom-E is now installed as a global command!"
echo -e "You can now run: \033[1mchrom-e --help\033[0m from anywhere 🧙"
echo -e "Run \033[1mchrom-e_healthcheck.sh --bootles-wootles\033[0m for purformance mode"
