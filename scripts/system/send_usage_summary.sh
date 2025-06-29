#!/bin/bash

# send_usage_summary.sh
# Generates a disk usage report, archives it, and emails it to the configured address.
# Designed for use with cron. Add this line to your crontab to automate monthly:
# 0 8 1 * * /home/your_username/chrom-e_tools/scripts/send_usage_summary.sh >> /home/your_username/chrom-e_log/cron.log 2>&1

# === USER CONFIG ===
EMAIL="you@example.com" # Replace with recipient's email address

# === SCRIPT CONFIG ===
DISK_SCRIPT="$HOME/chrom-e_tools/scripts/disk_usage_report.sh"
LOG_DIR="$HOME/chrom-e_log"
ARCHIVE_DIR="$LOG_DIR/archive"

# Make sure dirs exist
mkdir -p "$LOG_DIR"
mkdir -p "$ARCHIVE_DIR"

# Run the report in silent mode (saves to file)
"$DISK_SCRIPT" --bootles-wootles

# Find the latest generated report
LATEST_REPORT=$(ls -t "$LOG_DIR"/disk_report_*.txt | head -n 1)

# Archive it
cp "$LATEST_REPORT" "$ARCHIVE_DIR/"

# Email it
if [ -f "$LATEST_REPORT" ]; then
    cat "$LATEST_REPORT" | s-nail -s "Chrom-E Disk Summary: $(date +'%Y-%m-%d')" "$EMAIL"
    echo "📨 Report sent and archived."
else
    echo "‼️ Report not found. Skipping email."
fi
