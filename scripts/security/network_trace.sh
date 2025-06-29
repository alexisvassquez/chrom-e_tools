#!/bin/bash
# Chrom-E's Power Toolkit - network_trace.sh
# Traces and reports all active outbound connections with reverse DNS and geoIP tagging

echo "🌐 Running Network Trace..."

# Check if required tools are installed
REQUIRED_CMDS=("ss" "whois" "dig" "curl" "grep" "awk")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "❌ Missing dependency: $cmd"
        exit 1
    fi
done

# Gather all active outbound IP connections excluding LISTEN state
ss -ntu | awk 'NR>1 && $1 != "LISTEN" {print $5}' | cut -d: -f1 | sort -u > /tmp/active_ips.txt

if [ ! -s /tmp/active_ips.txt ]; then
    echo "⚠️ No active connections detected."
else
    echo "🕵️ Detected outbound connection:"
    while read -r ip; do
        rdns=$(dig +short -x "$ip" | sed 's/\.$//')
        whois_org=$(whois "$ip" | grep -iE 'OrgName|Organization|descr' | head -n1 | sed 's/^[^:]*: //')
        geo=$(curl -s "https://ipinfo.io/$ip/country")

        echo "🔸 IP: $ip"
        echo "  ↳ Reverse DNS: ${rdns:-Unavailable}"
        echo "  ↳ Organization: ${whois_org:-Unknown}"
        echo "  ↳ Country: ${geo:-Unknown}"
    done < /tmp/active_ips.txt
fi

rm -f /tmp/active_ips.txt
echo "✅ Trace complete."
