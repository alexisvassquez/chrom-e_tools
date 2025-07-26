#!/bin/bash

# 📘 Chrom-E's Power Toolkit: Help Index
# Run this script with ./chrom-e_help.sh or symlink as ./chrom-e --help

# Bootles ASCII + Quote Engine
print_bootles-wootles() {
cat << "EOF"

  /\_/\  
 ( o.o )   Bootles Wootles was here.
  > ^ <     

EOF

  # Bootles' randomized quotes
  quotes=(
    "Your system has been purformed."
    "Sniffed your logs. Smells optimized."
    "I walked across your keyboard and improved your uptime."
    "Security breach? Not on my watch."
    "System status: majestic."
    "I knocked over your swap file. You're welcome."
    "Purforming at peak efficiency."
    "Hacked the mainframe. Rolled over. Took a nap."
    "I cleaned your memory cache by flopping down on it."
    "Every byte you own, I have sat on."
  )

  # Pick a random one
  index=$((RANDOM % ${#quotes[@]}))
  bootles_line=${quotes[$index]}
  echo -e "$bootles_line"
  echo -e ""
}

# Flag: --bootles
if [[ "$1" == "--bootles" ]];then
    print_bootles-wootles
    exit 0
fi

# Special message if script is symlinked as `chrom-e`
SCRIPT_NAME="$(basename "$(readlink "0" 2>/dev/null || echo "$0")")"
if [[ "$SCRIPT_NAME" == "chrom-e" ]]; then
    echo -e "👋 Welcome to Chrom-E's Power Toolkit, your terminal sidekick."
    print_bootles-wootles
fi

# Main Help menu
echo -e "💾  Chrom-E's Power Toolkit Help Menu"
echo "────────────────────────────────────────────"
echo -e "This CLI-first toolkit is designed to optimize, secure, and maintain your Linux or containerized environment.\n" 
echo -e "Created by developers Alexis M Vasquez & Juniper.\n"

echo -e "🧪  System Optimization:"
echo -e "  ./chrome-e_healthcheck.sh  →  Full system diagnostic"
echo -e "  ./memory_report.sh         →  Show used/free memory and swap usage"
echo -e "  ./disk_usage_report.sh     →  Overview of mounted disk usage"
echo -e "  ./send_usage_summary.sh    →  Email a usage summary report via s-nail"
echo -e "  ./chrom-e_cli_cleaner.sh   →  Clean CLI temp files, logs, and history"
echo -e "  ./optimize_io.sh           →  Trim & sync SSD for faster disk I/O"
echo -e "  ./boost_cpu_governor.sh    →  Backup & switch CPU governor to performance (with restore)"
echo ""

echo -e "🔐  Networking & Cybersecurity:"
echo -e "  ./network_status.sh        →  View IP, active connections, reverse DNS + geoIP"
echo -e "  ./check_listeners.sh       →  Flag suspicious listening ports & processes"
echo -e "  ./suid_sweep.sh            →  Scan system for SUID binaries and log results"
echo -e "    --diff                   →  Compare current scan to baseline"
echo ""

echo -e "🔊  Audio Management:"
echo -e "  ./audio_flush.sh           →  Clear PulseAudio caches & restart audio"
echo ""

echo -e "🛠️  Maintenance:"
echo -e "  ./package_audit.sh         →  Audit installed, outdated & orphaned packages with bloat score"

echo -e "📚  Documentation & Utilities:"
echo -e "  ./chrom-e_help.sh          →  This help menu"
echo -e "  ./install_chrom-e.sh       →  Install global help command"
echo -e "    --bootles-wootles        →  Brief or silent-mode purformance system summary"
echo -e "    --log-path               →  Show where reports are saved"
echo -e "    --help                   →  Show help for healthcheck script"
echo ""

echo -e "📋  Scripts In Queue (Development-mode):"
echo -e "  ./cpu_temp_monitor.sh      →  Monitor CPU temps in °C and °F"
echo -e "  ./uptime_report.sh         →  Show system uptime and login count"
echo -e "  ./junk_finder.sh           →  Find & optionally delete common clutter"
echo -e "  ./refresh_swap.sh          →  Recreate swap file and reinitialize to clear swap clutter"
echo -e "  ./fix_mic.sh               →  Detect and reset faulty mic configs or reroute to working input."
echo -e "  ./clean_snap_flatpak.sh    →  Clears unused Snap/Flatpak app cache."
echo -e "  ./watch_network.sh         →  Watch for persistent connections to blacklisted corporate telemetry IP ranges in real-time."
echo -e "  ./brightness_lock.sh       →  Override auto-dimming and keep brightness consistent."
echo -e "And more...recurring updates!"
echo ""

echo -e "💡  Usage Tips:"
echo -e "- Make a script executable: chmod +x <scriptname>"
echo -e "- Run a script: ./scripts/<category>/<scriptname>.sh"
echo -e "- All logs are saved to: ~/chrom-e_log/"
echo -e "- Run with Bootles wisdom: ./package_audit.sh --bootles-wootles"
echo -e "- Run ./suid_sweep.sh with --diff to compare binaries to baseline"
echo ""

echo -e "📘 Repo: https://github.com/alexisvassquez/chrom-e_tools"
echo -e "🧙 Developed by: Alexis M Vasquez (Software Engineer, Full-Stack Developer, SysAdmin) and executive assistant, Juniper"
echo -e "🦾 Create Change Through Code."
