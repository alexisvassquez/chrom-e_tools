#!/bin/bash

#memory_report.sh
# Displays stylized system memory, swap, and top memory-using processes in a clear format.

# Define colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "\n${BOLD}${CYAN}🔎 MEMORY & SWAP USAGE REPORT${RESET}\n"

# Show total and used memory + swap
echo -e "${GREEN}>> Memory Snapshot:${RESET}"
free -h --si

# List top 10 processes by memory usage
echo -e "\n${BLUE}>> 📊 TOP 10 MEMORY-HOGGING PROCESSES BY USAGE:${RESET}\n"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11

# Show more detailed virtual memory stats if vmstat exists
echo -e "\n${YELLOW}>> 🧠 VIRTUAL MEMORY STATISTICS:${RESET}"
if command -v vmstat &> /dev/null; then
    vmstat -s
else
    echo -e "${RED}vmstat not found.${RESET} Install with: ${BOLD}sudo apt install procps${RESET}"
fi

echo -e "\n${BOLD}${GREEN}✅ Done.${RESET} For a more detailed live feed, try: ${CYAN}htop${RESET} or ${CYAN}watch -n 1 free -h${RESET}"
