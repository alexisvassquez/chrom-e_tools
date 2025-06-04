#!/bin/bash

# Chrom-E Health Check Script
# Generates a full system diagnostic report

LOG_DIR="$HOME/chrom-e_log"
LOG_FILE="$LOG_DIR/system_health_$(date '+%Y-%m-%d_%H-%M-%S').txt"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

echo "🔍 Chrom-E Health Check Report" | tee "$LOG_FILE"
echo "Generated on: $(date)" | tee -a "$LOG_FILE"
echo "Hostname: $(hostname)" | tee -a "$LOG_FILE"
echo "User: $USER" | tee -a "$LOG_FILE"
echo "--------------------------------------" | tee -a "$LOG_FILE"

# Uptime
echo -e "\n🕛 Uptime:" | tee -a "$LOG_FILE"
uptime -p | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# CPU Info
echo -e "\n🧠 CPU Info:" | tee -a "$LOG_FILE"
lscpu | grep -E 'Model name|Socket|Thread|Core|CPU\(s\)' | tee -a "$LOG_FILE"

# Memory
echo -e "\n💾 Memory Usage:" | tee -a "$LOG_FILE"
free -h | tee -a "$LOG_FILE"

# Disk Usage
echo -e "\n🗃️  Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Load Average
echo -e "\n📊 Load Average:" | tee -a "$LOG_FILE"
cat /proc/loadavg | tee -a "$LOG_FILE"

# Top 5 CPU-consuming Processes
echo -e "\n🌋 Top 5 CPU Processes:" | tee -a "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | tee -a "$LOG_FILE"

# Top 5 Memory-consuming Processes
echo -e "\n🪫 Top 5 Memory Processes:" | tee -a "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

# Temperature (if sensors available)
echo -e "\n🌡️ CPU Temperature:" | tee -a "$LOG_FILE"
if command -v sensors &> /dev/null; then
    SENSOR_OUTPUT=$(sensors 2>&1)
    if echo "$SENSOR_OUTPUT" | grep -iq "no sensors found"; then
        echo "⚠️  No temperature sensors detected. This is normal for sandboxed containers." | tee -a "$LOG_FILE"
        echo "ℹ️  Run 'sudo sensors-detect' outside the container or refer to https://wiki.archlinux.org/title/lm_sensors for advanced setup." | tee -a "$LOG_FILE"
    else
        echo "$SENSOR_OUTPUT" | tee -a "$LOG_FILE"
    fi
else
    echo -e "\n🌡️ CPU Temperature:\n'sensors' not installed. Run 'sudo apt-get install lm-sensors' to enable." | tee -a "$LOG_FILE"
fi

# End
echo -e "\n✅ Health check complete. Log saved to: $LOG_FILE"
