# Chrom-E's Power Toolkit for Lean Linux Systems 🐧
## CHANGELOG.md

## v1.4
- Added new networking & cybersecurity scripts:
  - `network_trace.sh`: Show active connections, perform reverse DNS + geoIP checks
  - `watch_network.sh`: Live monitor for known telemetry endpoints
  - `check_listeners.sh`: Detect suspicious listening ports & processes, with whitelisting
- Updated `chrom-e_help.sh` with new menu sections for Networking & Cybersecurity
- Improved script descriptions and usage tips
- Bumped version to v1.4
- Added new `CHANGELOG.md` to keep track of all changes

---

## [v1.5] – 2025-07-24
### Added
- New script: `package_audit.sh` audits user-installed, outdated, and orphaned packages across supported distros.
- Bootles Wootles offers randomized bloat wisdom with `--bootles-wootles`.
- Bloat score has ANSI color output!
- Includes support for multiple Linux distros

### Fixed
- Removed unstable `comm` + gzip method for manual package detection (Debian-based)
- Fixed `/dev/fd` permission error by switching to safer direct `apt-mark` logic
- Enhanced orphan detection with reverse dependency safety checks

---

## [v1.6] – 2025-07-25
### Security Enhancements
- Added `suid_sweep.sh` to `security/` directory.
  - Scans system for all SUID binaries and saves output to `~/chrom-e_log/security/`.
  - Includes `--diff` flag to compare current scan against baseline and detect new or modified binaries.
  - Automatically timestamps logs and preserves previous states.
  - Added smart logging via `log_note()` helper for consistent dual output (terminal + log file).
  - Introduced audit-friendly messaging with clear remediation notes.

### Toolkit Framework
- Introduced `log_note()` reusable helper function to standardize log + echo output across scripts.
- Improved UX clarity in logs when no changes are found during `--diff` mode.
- Ensured log retention logic works reliably and provides human-readable closure in all cases.

### Documentation + Help Menu
- Updated `chrom-e_help.sh` to include `suid_sweep.sh` under `🔐 Security Scripts` with `--diff` usage.
- Prepared structure for upcoming `ux/` directory in the help output.

---

## [1.7.0] - 2025-08-20
### Added
- `temp_file_tracker.sh`: scan temp/cache directories and list top-N largest files with a size threshold.
  - Flags: `-s/--min-size` (e.g., `10M`, `1G`), `-n/--limit`, `-t/--targets`.
  - Summaries per directory + aggregate total across all targets.
- Help menu entry: added `./temp_file_tracker.sh` under **Maintenance** in `chrom-e_help.sh`.
- Usage tip: example invocation added to **Usage Tips** in `chrom-e_help.sh`.

### Fixed
- `temp_file_tracker.sh`: closed help heredoc delimiter and corrected `awk -v b="$1"` assignment in `hr_bytes()`.
