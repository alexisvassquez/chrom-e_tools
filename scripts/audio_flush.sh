#!/usr/bin/env bash
# audio_flush.sh
# This script will reset PulseAudio: stop it, clear cache & runtime files, then restart.
# NOTE: Best run as your normal user (no use of sudo)

set -euo pipefail
shopt -s nullglob

########## 0. Prevent running as root ##########
if (( EUID == 0 )); then
    echo "⚠️ Detected root. Please run this script as your normal user to clear your personal PulseAudio state."
fi

# Helper for nicer output
log() {
    echo "🔊 $1";
}

########## 1. Check for PulseAudio binary ##########
if ! command -v pulseaudio &> /dev/null; then
    echo "⚠️ pulseaudio not found in \$PATH - is it installed?" >&2
    exit 1
fi

########### 2. Detect systemd --user should be used vs plain daemon ##########
# check is pulseaudio.unit exists
USE_SYSTEMD=false
if systemctl --user &> /dev/null && \
    systemctl --user list-units --full --no-legend \
        | grep -qE 'pulseaudio\.service|pulseaudio\.socket'; then
    USE_SYSTEMD=true
fi

######### 3. Stop/kill PulseAudio ###########
log "Stopping PulseAudio..."
if $USE_SYSTEMD; then
    systemctl --user stop pulseaudio.service pulseaudio.socket >/dev/null 2>&1 || true
else
    pulseaudio --kill >/dev/null 2>&1 || true
fi

######### 4. Wipe config & cache dirs ##########
log "Removing PulseAudio config & cache..."
for dir in \
    "${XDG_CONFIG_HOME:-$HOME/.config}"/pulse \
    "$HOME/.pulse" \
    "${XDG_CACHE_HOME:-$HOME/.cache}"/pulse \
; do
    if [[ -d "$dir" ]]; then
        rm -rf "$dir" \
            && log "  🔵 Wiped $dir" \
            || log "  ⚠️ Could not remove $dir"
    fi
done

######### 5. Remove any runtime sockets under /tmp ###########
log "Cleaning runtime sockets (/tmp/pulse-*)..."
for sock in /tmp/pulse-*/; do
    # nullglob ensures only real dirs here
    if [[ -e "$sock" ]]; then
        rm -rf "$sock" \
            && log "  🔵 Removed $sock" \
            || log "  ⚠️ Could not remove $sock (permission denied)"
    fi
done

######### 6. Restart PulseAudio ##########
log "Restarting PulseAudio..."
if $USE_SYSTEMD; then
    systemctl --user start pulseaudio.service pulseaudio.socket >/dev/null 2>&1 || true
else
    pulseaudio --start >/dev/null 2>&1 || true
fi

log "✅ PulseAudio has been flushed and restarted!"
