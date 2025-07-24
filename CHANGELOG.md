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

