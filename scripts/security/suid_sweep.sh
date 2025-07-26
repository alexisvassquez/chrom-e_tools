#!/bin/bash
# Chrom-E's Power Toolkit: suid_sweep.sh
# Scan for SUID (SetUID) binaries that may be potential privilege escalation risks.

# Begins scan and saves log of SUID binaries
echo "👀 [Chrom-E] Starting SUID binary scan..."
LOG_DIR="$HOME/chrom-e_log/security"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +%F_%H-%M-%S)
LOG_FILE="$LOG_DIR/suid_sweep_$TIMESTAMP.log"

BASELINE="$LOG_DIR/suid_baseline.txt"

# ==== Reusable helper functions ====
log_note() {
    # Usage: log_note "Your message" /path/to/file.log
    echo -e "$1" | tee -a "$2"
}

# --diff mode
# Compare current SUID scan to a saved baseline
# New entries will set alert
if [[ "$1" == "--diff" ]]; then
    echo "🔁 [Chrom-E] Running SUID diff check against baseline..."

    if [[ ! -f "$BASELINE" ]]; then
        echo "⚠️  No baseline found. Saving current scan as baseline."
        find / -type f -perm -4000 2>/dev/null | sort | tee "$BASELINE"
        echo "✅  Baseline saved to: $BASELINE"
        exit 0
    fi

    # Rotate baseline if it's older than 7 days
    baseline_age_days=$(( ( $(date +%s) - $(stat -c %Y "$BASELINE") ) / 86400 ))
    if (( baseline_age_days > 7 )); then
        ROTATED="$LOG_DIR/suid_baseline_rotated_$TIMESTAMP.txt"
        mv "$BASELINE" "$ROTATED"
        echo "♻️  Baseline older than 7 days. Rotating...."
        echo "📁 Rotated old baseline to: $ROTATED"
        echo "📥 Creating fresh baseline...."
        find / -type f -perm -4000 2>/dev/null | sort | tee "$BASELINE"
        echo "☑️  New baseline saved to: $BASELINE"
         exit 0
     fi

    CURRENT_TMP="$LOG_DIR/suid_current_tmp_$TIMESTAMP.txt"
    DIFF_FILE="$LOG_DIR/suid_diff_$TIMESTAMP.log"

    echo "🔍  Scanning current SUID binaries...."
    find / -type f -perm -4000 2>/dev/null | sort | tee "$CURRENT_TMP"

    echo "📊  Comparing current results to baseline..."
    diff "$BASELINE" "$CURRENT_TMP" | tee "$DIFF_FILE"

    if [[ -s "$DIFF_FILE" ]]; then
        log_note "🚨  New or changed SUID binaries detected!" "$DIFF_FILE"
        log_note "❕  Review any unusual paths or binaries. Most legit SUIDs live in /bin, /usr/bin, /sbin." "$DIFF_FILE"
        echo "📂  Diff log saved to: $DIFF_FILE"
    else
        log_note "☑️   No differences found. SUID state unchanged." "$DIFF_FILE"
        log_note "📭  No SUID changes found. Nothing to report." "$DIFF_FILE"
        log_note "🧼  Nothing suspicious. Chrom-E approves this clean binary hygiene." "$DIFF_FILE"
        echo "📂  Diff note saved to: $DIFF_FILE" 
    fi

    rm "$CURRENT_TMP"
    exit 0
fi

# Default scan mode
find / -type f -perm -4000 2>/dev/null | sort | tee "$LOG_FILE" 

echo ""
echo "✅ Scan complete."
echo "🗂️  Results saved to: $LOG_FILE"
log_note "❕ Review any unusual paths or binaries. Most legit SUIDs live in /bin, /usr/bin, /sbin." "$LOG_FILE"
