#!/bin/bash

# optimize_io.sh
# Improve I/O performance by tuning system parameters
# Chrom-E's interactive I/O optimization
# Logs actions and settings to ~/chrom-e_log/optimize_io.log

USER_HOME=$(eval echo "~$SUDO_USER")
LOG_DIR="$USER_HOME/chrom-e_log"
LOG_FILE="$LOG_DIR/optimize_io.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

confirm() {
    read -rp "$1 [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script as root using sudo."
    exit 1
fi

log "🔧 Starting I/O performance optimization...."

# 1. Set I/O scheduler
for dev in  /sys/block/*/queue/scheduler; do
    base=$(basename "$(dirname "$(dirname "$dev")")")

    # Skip virtual/non-physical devices (loop, ram, zram, virtio)
    if [[ "$base" =~ ^(loop|ram|zram|vd)[a-z0-9]+$ ]]; then
        log "⏭️ Skipped virtual device: $base"
        continue
    fi

    sched=$(cat "$dev")
    log "Current scheduler for $dev: $sched"

    if confirm "Set I/O scheduler to 'deadline' for $dev?"; then
        if grep -q 'deadline' "$dev"; then
            echo deadline > "$dev" 2>/dev/null && \
                log "✅ Set scheduler to 'deadline' for $dev" || \
                log "❌ Failed to set scheduler for $dev (permission denied)"
        elif grep -q 'mq-deadline' "$dev"; then
            echo mq-deadline > "$dev" 2>/dev/null && \
                log "✅ Set scheduler to 'mq-deadline' for $dev" || \
                log "❌ Failed to set scheduler for $dev (permission denied)"
        else
            log "⚠️ 'deadline' or 'mq-deadline' not found for $dev"
        fi
    else
        log "⏭️ Skipped scheduler change for $dev"
    fi
done

# 2. Lower dirty ratios for faster cache flushing
if confirm "Lower dirty cache ratios (10/5)?"; then
    if [ ! -w /proc/sys/vm/dirty_ratio ] || [ ! -w /proc/sys/vm/dirty_background_ratio ]; then
        log "⚠️ Cannot modify dirty ratios. Likely restricted by sandbox (Crostini or container)."
    elif echo 10 | tee /proc/sys/vm/dirty_ratio > /dev/null && echo 5 | tee /proc/sys/vm/dirty_background_ratio > /dev/null; then
        log "✅ Dirty cache ratios set (10/5)"
    else
        log "❌ Failed to set dirty cache ratios (permission denied)"
    fi 
else
    log "⏭️ Skipped dirty cache tuning"
fi

# 3. Drop filesystem (FS) caches
if confirm "Drop filesystem caches now (sync + echo 3 > drop_caches)?"; then
    if [ ! -w /proc/sys/vm/drop_caches ]; then
        log "⚠️ Cannot drop caches. Likely restricted by sandbox (Crostini or container)."
    elif sync && echo 3 | tee /proc/sys/vm/drop_caches > /dev/null; then
        log "✅ Dropped filesystem caches"
    else
        log "❌ Failed to drop filesystem caches (permission denied)"
    fi
else
    log "⏭️ Skipped cache drop"
fi
 
# 4. Tweak swappiness
total_mem=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
if [ "$total_mem" -lt 4000000 ]; then
    if confirm "RAM < 4GB detected. Set swappiness for 10?"; then
        if [ ! -w /proc/sys/vm/swappiness ]; then
            log "⚠️ Cannot modify swappiness. Likely restricted by sandbox (Crostini or container)."
        elif echo 10 | tee /proc/sys/vm/swappiness > /dev/null; then
            log "✅ Swappiness set to 10 (for low RAM systems)."
        else
            log "❌ Failed to set swappiness (permission denied)"
        fi
    else
        log "⏭️ Skipped swappiness change"
    fi
else
    log "💡 RAM > 4GB, swappiness tweak skipped"
fi

log "ℹ️ Note: These changes are not persistent and will reset on reboot."
log "🎯 I/O optimization script completed successfully."
echo "🎊 I/O optimization complete."
