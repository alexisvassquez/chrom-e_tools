#!/usr/bin/env bash
# boost_cpu_governor.sh
# The purpose of this script is to switch all CPU cores to the *performance* governor for maximum responsiveness.
# Will auto-detect either policy*/ or cpu*/cpufreq layout.
# Restores from the last backup
# Usage:
#    ./boost_cpu_governor.sh          # backup & switch all to *performance* mode
#    ./boost_cpu_governor.sh restore  # restore from the last backup

set -euo pipefail

REQUIRED_GOV="performance"
BACKUP_DIR="/var/lib/boost_cpu_governor"
BACKUP_FILE="$BACKUP_DIR/prev_governors"

die() { echo "❌ $1" >&2; exit 1; }
usage() {
    cat <<EOF
Usage: $0 [restore]

No args: Backup current governors → set all cores/policies to '$REQUIRED_GOV'
restore|-r: Restore governors from last backup
EOF
    exit 1
} 

# Ensure script is run as root
# Enable nullglob so unmatched globs vanish instead of literal strings
[[ $EUID -eq 0 ]] || die "⚠️ This script must be run as root. Try: sudo $0"
shopt -s nullglob

########## 1. Collect cpufreq knobs (policy*/ or cpu*/cpufreq layout) ##########
gov_paths=( \
    /sys/devices/system/cpu/cpufreq/policy*/scaling_available_governors \
    /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_available_governors\
)

# If none found, no-op cleanly
if (( ${#gov_paths[@]} == 0 )); then
    echo "ℹ️  CPUfreq governors not exposed in this environment - nothing to do."
    exit 0
fi

########## 2. Handle restore mode ###########
if [[ $# -eq 1 ]]; then
    case "$1" in
        restore|-r)
            [[ -f "$BACKUP_FILE" ]] || die "No backup found at $BACKUP_FILE"
            echo "🔄 Restoring CPU governors from backup..."
            while IFS='=' read -r path gov; do
                if [[ -w "$path" ]]; then
                    echo "$gov" > "$path"
                    echo "  🔵 $(basename "$(dirname "$path")") → $gov"
                else
                    echo "  ⚠️ Cannot write to $path; skipping."
                fi
            done < "$BACKUP_FILE"
            echo "✅ Restore complete!"
            exit 0
            ;;
        *) usage ;;
    esac
elif [[ $# -gt 1 ]]; then
    usage
fi

########## 3. Default: backup current, then switch to performance ########
# Prompt before overwriting when a backup already exists (if needed)
if [[ -f "$BACKUP_FILE" ]]; then
    read -r -p "⚠️ Backup exists at $BACKUP_FILE and will be overwritten. Continue? [y/N] " ans
    case "$ans" in 
        [Yy]*) ;; 
        *) echo "Aborting..."; exit 0 ;; 
    esac
fi

# Backup current settings
echo "💾 Backing up current governors to $BACKUP_FILE"
mkdir -p "$BACKUP_DIR"
: > "$BACKUP_FILE"
for p in "${avail_paths[@]}"; do
    echo "$p=$(< "$p")" >> "$BACKUP_FILE"
done 

######### 4. List available scaling_governor knobs ###########
avail_paths=( \
    /sys/devices/system/cpu/cpufreq/policy*/scaling_governor \
    /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor \
)
if (( ${#avail_paths[@]} )); then
    echo
    echo "🔍 Available governors:"
    for p in "${avail_paths[@]}"; do
        node=$(basename "$(dirname "$p")")
        echo "  🔵 $node → $(<"$p")"
    done
fi

########## 5. Apply the governor and switch to performance ##########
echo
echo "🚀 Switching all cores/policies to '$REQUIRED_GOV'..."
for p in "${gov_paths[@]}"; do
    echo "$REQUIRED_GOV" > "$p"
done

######### 6. Verify ############
echo
echo "✅ Verifying new governor settings:"
fail=0
for p in "${gov_paths[@]}"; do
    node=$(basename "$(dirname "$p")")
    current=$(<"$p")
    if [[ "$current" == "$REQUIRED_GOV" ]]; then
        echo "  ✓ $node → $current"
    else
        echo "  ✗ $node → $current"
        fail=1
    fi
done

if (( fail == 0 )); then
    echo
    echo "🎉 All cores/policies are now in '$REQUIRED_GOV' mode!"
    exit 0
else
    echo
    echo "❗ Some cores/policies failed to switch. Check permissions or governor availability above."
    exit 2
fi
