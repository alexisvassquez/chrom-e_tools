#!/bin/bash
# Chrom-E's Power Toolkit - check_listeners.sh
# Scans for unexpected LISTEN state ports and flags potential suspicious services.
# Displays process info
# Whitelists trusted process names

echo "👀 Scanning for listening ports..."

# Define allowed (known safe) ports here
ALLOWED_PORTS=("22" "80" "443" "631")   # Ex: SSH, HTTP, HTTPS, CUPS
TRUSTED_PROCESSES=("glances" "htop")

# Get current listening ports with process info
lsof -nP -iTCP -sTCP:LISTEN > /tmp/listeners_lsof.txt

if [ ! -s /tmp/listeners_lsof.txt ]; then
    echo "🕵️ No listening ports found."
else
    echo "🔍 Currently listening ports and processes:"
    cat /tmp/listeners_lsof.txt
    echo ""

    # Compare against allowed list and parse lsof output
    tail -n +2 /tmp/listeners_lsof.txt | while read -r line; do
        procname=$(echo "$line" | awk '{print $1}')
        pid=$(echo "$line" | awk '{print $2}')
        port=$(echo "$line" | awk '{print $9}' | sed -E 's/.*:([0-9]+)->.*/\1/;s/.*:([0-9]+)/\1/')

        skip_port=0
        skip_proc=0

        for allowed in "${ALLOWED_PORTS[@]}"; do
            if [[ "$port" == "$allowed" ]]; then
                skip_port=1
            fi
        done

        for trusted in "${TRUSTED_PROCESSES[@]}"; do
            if [[ "$procname" == "$trusted" ]]; then
                skip_proc=1
            fi
        done

        if [[ "$skip_port" -eq 0 && "$skip_proc" -eq 0 ]]; then
            echo "🚨 [ALERT] Unknown listening port detected: $port"
            echo "   ↳ Process Info: ${procname:-Unknown}"
            echo "   ↳ PID: ${pid:-Unknown}"
            echo ""
            echo "💡 Tip: Use 'lsof -i :$port' or 'ps -p $pid' for deeper inspection."
        fi
    done
fi

rm -f /tmp/listeners_lsof.txt
echo "✅ Listener scan complete."
