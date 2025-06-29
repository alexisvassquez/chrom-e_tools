#!/bin/bash

echo "🧼 Starting Chrom-E System Cleanup..."

# Update and upgrade packages
echo "🔄 Updating package lists..."
sudo apt update && sudo apt upgrade -y

# Clean up apt cache
echo "🗑️  Cleaning apt cache..."
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y

# Remove old thumbnails
echo "🖼️  Removing old thumbnails..."
rm -rf ~/.cache/thumbnails/*

# Clear systemd journal logs (use with caution)
echo "📜 Clearing journal logs..."
sudo journalctl --vacuum-time=7d

# Identify and report large directories
echo "📦 Top 10 largest directories in home:"
du -sh ~/* 2>/dev/null | sort -hr | head -n 10

echo "✅ Chrom-E Cleanup Complete! Your system is feeling snazzy ✨"
