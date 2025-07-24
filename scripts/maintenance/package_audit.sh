#!/bin/bash
# Chrom-E's Power Toolkit: Package Audit
# List user-installed packages, outdated packages, and orphaned libraries
# Includes Bootles Bloat Rating & Dependency Safety Checks

bootles_mode=false

if [[ "$1" == "--bootles-wootles" ]]; then
    bootles_mode=true
fi

echo "Chrom-E's Package Audit Tool"
echo "──────────────────────────────────────────────"

manual_count=0
outdated_count=0
orphan_count=0
DISTRO="unknown"

# Detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
fi

echo "🧠 Detected Distro: $PRETTY_NAME"

# Debian/Ubuntu logic
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
    echo -e "\n🔍 User-Installed Packages:"
    manual_pkgs=$(apt-mark showmanual | sort)
    if [ -z "$manual_pkgs" ]; then
        echo "No manually installed packages found."
    else
        echo "$manual_pkgs"
        manual_count=$(echo "$manual_pkgs" | wc -l)
    fi

    # Show packages with available updates
    echo -e "\n⬆️ Outdated Packages:"
    sudo apt-get update -qq > /dev/null
    outdated_pkgs=$(apt-get -s upgrade | grep "^Inst")
    echo "$outdated_pkgs"
    outdated_count=$(echo "$outdated_pkgs" | wc -l)

    # Show orphaned packages (libs with no dependents if deborphan is available)
    echo -e "\n🧹 Orphaned Packages (libs with no dependents):"
    if command -v deborphan &> /dev/null; then
        orphaned=$(deborphan)
        for pkg in $orphaned; do
            echo -n "🔎 $pkg -> "
            rdepends=$(apt-cache rdepends --installed "$pkg" 2>/dev/null | awk 'NR>1 && NF')
            if [ -z "$rdepends" ]; then
                echo "❕ No dependents"
            else
                echo "⚠️ Reverse deps found:" 
                echo "$rdepends" | sed 's/^/    - /'
            fi
        done
        orphaned_count=$(echo "$orphaned" | wc -l)
    else
        echo "⚠️ 'deborphan' not installed. Run 'sudo apt install deborphan' to enable this feature."
    fi

# Arch logic
elif [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" ]]; then
    echo -e "\n 🔍 User-Installed Packages:"
    manual_pkgs=$(pacman -Qent)
    echo "$manual_pkgs"
    manual_count=$(echo "$manual_pkgs" | wc -l)

    echo -e "\n⬆️ Outdated Packages:"
    outdated_pkgs=$(checkupdates 2>/dev/null || yay -Qu 2>/dev/null)
    echo "$outdated_pkgs"
    outdated_count=$(echo "$outdated_pkgs" | wc -l)

    echo -e "\n🧹 Orphaned Packages:"
    orphaned=$(pacman -Qdtq)
    echo "$orphaned"
    orphaned_count=$(echo "$orphaned" | wc -l)

# Alpine logic
elif [[ "$DISTRO" == "alpine" ]]; then
    echo -e "\n🔍 User-Installed Packages:"
    manual_pkgs=$(apk info -vv | grep 'installed by' | awk '{print $1}')
    echo "$manual_pkgs"
    manual_count=$(echo "$manual_pkgs" | wc -l)

    echo -e "\n⬆️ Outdated Packages:"
    outdated_pkgs=$(apk version -1 '<')
    echo "$outdated_pkgs"
    outdated_count=$(echo "$outdated_pkgs" | wc -l)

    echo -e "\n🧹 Orphaned Packages:"
    echo "⚠️ Orphan detection not available in Alpine's apk."
    orphan_count=0

# Fedora logic
elif [[ "$DISTRO" == "fedora" ]]; then
    echo -e "\n🔍 User-Installed Packages:"
    manual_pkgs=$(dnf repoquery --userinstalled --qf "%{name}")
    echo "$manual_pkgs"
    manual_count=$(echo "$manual_pkgs" | wc -l)

    echo -e "\n⬆️ Outdated Packages:"
    outdated_pkgs=$(dnf check-update -q | grep -E '^\S' || true)
    echo "$outdated_pkgs"
    outdated_count=$(echo "$outdated_pkgs" | wc -l)

    echo -e "\n🧹 Orphaned Packages:"
    orphaned=$(dnf repoquery --extras)
    echo "$orphaned"
    orphan_count=$(echo "$orphaned" | wc -l)

else
    echo "❌ Unsupported distro: $DISTRO"
    exit 1
fi

# Totals
echo -e "\n📊 Totals:"
echo "User-installed: $manual_count"
echo "Outdated:       $outdated_count"
echo "Orphaned:       $orphan_count"

# Bloat Score
score=$((manual_count + outdated_count + orphan_count))
echo -n -e "\n💡 Bloat Score: $score -> "

if (( score < 50 )); then
    color="\e[1;32m"    # Bright green
    rating="🧼 Ultra Lean"
elif (( score < 100 )); then
    color="\e[1;36m"    # Cyan
    rating="🐧 Lightweight"
elif (( score < 200 )); then
    color="\e[1;35m"    # Bright magenta
    rating="🌯 Getting Chunky"
else
    color="\e[1;31m"    # Red
    rating="🍔 FULL BLOAT DETECTED"
fi

echo -e "${color}${rating}\e[0m"

# Bootles Wisdom
if $bootles_mode; then
    echo -e "\nBootles Wootles bloat wisdom:"
    bootles_quotes=(
        "I purged your bloated bits in my litter box."
        "That bloat score? Offensive. I'm shedding in protest."
        "This system is leaner than my tail in high alert mode."
        "I rated your system 🌯 and gave it a side eye."
        "I de-bloated your kernel with a single swipe."
        "Purring....but slightly concerned about those orphans."
        "Your sysem is majestic. But your cache is not."
        "Lean enough to nap on. Proceed."
    )
    quote_index=$((RANDOM % ${#bootles_quotes[@]}))
    echo "💬 ${bootles_quotes[$quote_index]}"
fi

echo -e "\n✅ Package audit complete."
