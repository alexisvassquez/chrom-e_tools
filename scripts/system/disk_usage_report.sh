#!/bin/bash

# disk_usage_report.sh
# Shows a detailed, extended disk usage snapshot with mounted partitions, largest directories, and optional warnings.
# Includes save and silent modes.

DATE="$(date +%Y-%m-%d_%H-%M-%S)"
LOG_DIR="$HOME/chrom-e_log"
SAVE_FILE="$LOG_DIR/disk_report_$DATE.txt"
SILENT_MODE=false
SAVE_MODE=false

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --save)
            SAVE_MODE=true
            ;;
        --bootles-wootles)
            SAVE_MODE=true
            SILENT_MODE=true
            ;;
        *)
            ;;
    esac
done

# Output function wrapper
output() {
    if [ "$SILENT_MODE" = false ]; then
        echo -e "$1"
    fi
    if [ "$SAVE_MODE" = true ]; then
        echo -e "$1" >> "$SAVE_FILE"
    fi
}

# Begin report
output "----------------------------------------"
output "📦 DISK USAGE REPORT - $(date)"
output "----------------------------------------"

# General disk usage overview
output "\n🧠 Overall Filesystem Usage:"
output "$(df -h --total | grep -E '^FileSystem|total')"

#  Show top 20 largest on root (excluding virtual filesytems)
output "\n🗂️ Top 20 Largest Directories in/:"
output "$(sudo du -h / --max-depth=1 2>/dev/null \
    | grep -vE "^du:|/proc|/sys|/dev|/run|/snap" \
    | sort -hr | head -n 20)"

# Detailed breakdown of home directory
output "\n👤 Your Home Directory (Top 10):"
output "$(du -h ~ --max-depth=1 2>/dev/null \
    | sort -hr | head -n 10)"

# Check root usage and warn if over threshold
ROOT_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$ROOT_USAGE" -gt 80 ]; then
    output "\n⚠️ Warning: Root partition usage is at ${ROOT_USAGE}%!"
fi

output "\n✅ Done. Consider running \`sudo apt autoremove && sudo apt clean\` if space is tight."
output "----------------------------------------"

# Exit message if in save mode
if [ "$SAVE_MODE" = true ] && [ "$SILENT_MODE" = false ]; then
    echo "📂 Report saved to $SAVE_FILE"
fi
