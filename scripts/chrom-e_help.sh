#!/bin/bash

# 📘 Chrom-E Power Toolkit: Help Index
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
    echo -e "👋 Welcome to Chrom-E, your terminal sidekick."
    print_bootles-wootles
fi

# Main Help menu
echo -e "💾 Chrom-E Power Toolkit Help Menu"
echo "────────────────────────────────────────────"
echo -e "This terminal-based toolkit is designed for Linux systems, Crostini, and other sandboxed containers in need of a boost." 
echo -e "Created by developers Alexis M Vasquez & Juniper.\n"

echo -e "🧪 Available Scripts:"
echo -e "  ./chrome-e_healthcheck.sh  →  Full system diagnostic"
echo -e "    --bootles-wootles        →  Brief or silent-mode purformance system summary"
echo -e "    --log-path               →  Show where reports are saved"
echo -e "    --help                   →  Show help for healthcheck script"
echo ""

echo -e "  ./memory_report.sh         →  Show used/free memory and swap usage"
echo -e "  ./disk_usage_report.sh     →  Overview of mounted disk usage"
echo -e "  ./send_usage_summary.sh    →  Email a usage summary report via s-nail"
echo -e "  ./chrom-e_cli_cleaner.sh   →  Clean CLI temp files, logs, and history"
echo ""

echo -e "📋 Scripts In Queue (Development-mode):"
echo -e "  ./optimize_io.sh           →  Trim & sync SSD for faster disk I/O"
echo -e "  ./audio_flush.sh           →  Clear PulseAudio caches & restart audio"
echo -e "  ./network_status.sh        →  View IP, Wi-Fi signal, DNS, and ping"
echo -e "  ./cpu_temp_monitor.sh      →  Monitor CPU temps in °C and °F"
echo -e "  ./uptime_report.sh         →  Show system uptime and login count"
echo -e "  ./junk_finder.sh           →  Find & optionally delete common clutter"
echo ""

echo -e "💡 Usage Tips:"
echo -e "- Make a script executable: chmod +x <scriptname>"
echo -e "- Run a script: ./<scriptname>.sh"
echo -e "- All logs are saved to: ~/chrom-e_log/"
echo ""

echo -e "📘 Repo: https://github.com/alexisvassquez/chrom-e_tools"
echo -e "🧙 Developed by: Alexis M Vasquez (Software Engineer, Full-Stack Developer, SysAdmin) and executive assistant, Juniper"
echo -e "🦾 Create Change Through Code. Fewer Clicks, More Power, All Floppy." 
