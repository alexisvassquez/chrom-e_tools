#!/bin/bash
# Chrom-E's Power Toolkit: temp_file_tracker.sh
# Show top space-hoggers in temp/cache dirs
# Usage: ./temp_file_tracker.sh
#    MIN_SIZE: minimum file size (10M default)
#    LIMIT: how many files to show (20 default)

# Notes:
#  - MIN_SIZE accepts optional unit: K, M, G (case-insensitive)
#  - LIMIT must be a positive integer
#  - Uses sudo only when needed for system dirs

set -euo pipefail

MIN_SIZE="10M"
LIMIT=20
TARGETS_DEFAULT="/tmp /var/tmp $HOME/.cache /var/cache/apt/archives"
TARGETS="$TARGETS_DEFAULT"

print_help() {
  cat <<EOF
🧹 Temp/Cache Scan - min size
Find and list the biggest files in common temp/cache dirs.

Usage:
  $(basename "$0") [options]

Options:
  -s, --min-size <SIZE>    Minimum file size to report (e.g., 10M, 500K, 1G). Default is 10M.
  -n, --limit <N>          Number of files to display per directory. Default: 20
  -t, --targets "<dirs>"   Quoted, space-separted list of directories to scan.
                           Default: $TARGETS_DEFAULT
  -h, --help               Show this help.
EOF
}

# Long/short option parsing
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--min-size)
      [[ $# -ge 2 ]] || { echo "Missing value for $1"; exit 2; }
      MIN_SIZE="$2"; shift 2 ;;
    -n|--limit)
      [[ $# -ge 2 ]] || { echo "Missing value for $1"; exit 2; }
      LIMIT="$2"; shift 2 ;;
    -t|--targets)
      [[ $# -ge 2 ]] || { echo "Missing value for $1"; exit 2; }
      TARGETS="$2"; shift 2 ;;
    -h|--help)
      print_help; exit 0 ;;
    --) shift; break ;;
    *)
      echo "Unknown option: $1"; echo; print_help; exit 2 ;;
  esac
done

TARGETS=$(eval echo $TARGETS)

# Validation
# shellcheck disable
if ! [[ "$MIN_SIZE" =~ ^[0-9]+([KkMmGg])?$ ]]; then
  echo "Invalid --min-size '$MIN_SIZE'. Use forms like 500K, 10M, 1G."; exit 2
fi
if ! [[ "$LIMIT" =~ ^[1-9][0-9]*$ ]]; then
  echo "Invalid --limit '$LIMIT'. Must be a positive integer."; exit 2
fi

echo "🧹 Temp/Cache Scan - min size >= ${MIN_SIZE}, top ${LIMIT} files"
echo "==============================================================="
date +"Started: %F %T"
echo

total_bytes=0

# human-readable bytes
hr_bytes() {
  if command -v numfmt >/dev/null 2>&1; then
    numfmt --to=si --suffix=B "$1"
  else
    awk -v b="$1" 'BEGIN{
      split("B KB MB GB TB",u); s=1;
      while (b>1024 && s<5){b/=1024; s++}
      printf("%.2f %s", b, u[s])
    }'
  fi
}

for d in ${TARGETS}; do
  [[ -d "$d" ]] || { echo "📂 $d (skipped: not a directory)"; echo; continue; }

  # Directory total
  echo "📂 $d"
  dir_total=$(du -sh "$d" 2>/dev/null | awk '{print $1}')
  echo "    Total size: ${dir_total:-unknown}"

  # Top files
  # Sort numeric desc, take top LIMIT
  # Use sudo for system dirs if needed
  FIND_CMD=(find "$d" -xdev -type f -size +"$MIN_SIZE" -printf '%s %p\n')
  if [[ ! -r "$d" ]]; then
    FIND_CMD=(sudo "${FIND_CMD[@]}")
  fi

  if "${FIND_CMD[@]}" 2>/dev/null \
      | sort -nr | head -n "$LIMIT" \
      | awk '
          BEGIN{got=0}
          {
            bytes=$1; $1="";
            path=substr($0,2);
            # convert to human-readable size format
            split("B KB MB GB TB", u); s=1; while (bytes>=1024 && s<5){bytes/=1024; s++}
            if (got==0) {print "    Top files:"}
            printf("    - %6.2f %s  %s\n", bytes, u[s], path);
            got=1
          }
          END{ if (got==0) print "    (no files >= threshold)" }
        '
  then : ; fi

  # Sum bytes (fast approx. with `du`)
  dir_bytes=$(du -sb "$d" 2>/dev/null | awk '{print $1}')
  if [[ -n "${dir_bytes:-}" ]]; then
    total_bytes=$(( total_bytes + dir_bytes ))
  fi
  echo
done

echo "📦 Aggregate total across targets: $(hr_bytes "${total_bytes:-0}")"
echo "Done."
