# Chrom-E's Power Toolkit for Lean Linux Systems 🐧
Welcome to the official shell script collection inspired by **Chrom-E** - a one-of-a-kind *hybrid system* forged in the fires of *firmware tweaks, channel switching,* and *terminal wizardry.*
This repo is dedicated to my device **Chrom-E,** an unbreakable and *powerful* Chromebook that has defied all odds. It is a collection of custom shell scripts designed to power up your Linux system and keep a lightweight dev environment running smoothly.

These shell scripts were born out of necessity - crafted to clean, maintain, assist, and give superpowers to a constrained Linux development environment (like a *Crostini-powered Chromebook*) without compromising performance. Whether you're low on RAM, juggling large AI projects, or just looking for smart, CLI-first hygiene - this toolkit is for you.

---

## The Tale of Chrom-E
**Chrom-E** started life as a modest Chromebook. However, after a series of developer channel experiments *(stable > beta > developer > repeat)*, wiping configs, multiple Crostini power-washes, and toggling Crostini on and off - **Chrom-E** rose from the ashes like a phoenix as something else. Something more powerful. Not quite *ChromeOS*, not fully *Linux*, but something inbetween...a *hybrid system*. He's **Chrom-E!**

He transcended his limitations and is now not *just* running ChromeOS or Linux - he's running both and neither, at the same time. One day the Play Store and the Phone Hub disappeared...and never came back. What came in its place was a Chromium exoskeleton fused with Ubuntu/Debian DNA. Mutant? Possibly. Magical? Most definitely.

> "You can't buy Chrom-E. You have to build him." 

---

## Why Chrom-E Matters
**Chrom-E** defies the narrative that you *need* a high-end device to code, build, and *innovate.* He's proof that a constrained environment can still produce greatness - especially when paired with the right tools.

These scripts are CLI-first utilities designed to help:
- Clean your system's clutter (cache, dead kernels, and more)
- Monitor memory, disk, and CPU usage
- Stay lightweight while developing high-impact projects
- Learn foundational Linux hygiene practices

If you're a developer working from an old laptop, a budget device, or even a low-end setup - you're not alone. This repo is for you.

---

## 🧬 Chrom-E's Technical Specs & Capabilities
**Chrom-E** is *not* your typical Chromebook. He's a liminal system - caught between *ChromeOS* and *Linux* but fully thriving in both worlds. Here's what makes him so special:

### Core Specs:
| Component | Details|
| ------ | --------- |
| Codename | `babytiger` (adorable, but deceptive) |
| Model | ASUS Chromebook C523NA (x86_64 architecture) |
| CPU | Intel Celeron N4020 @ 1.10GHz x 2 (dual-core, burst up to 2.4GHz) |
| RAM | 4GB physical (419304 KiB) |
| Channel | `ltc-channel coral` (Long Term Channel...with a custom spin) |
| Firmware | `Google_Coral.10068.113.0` |
| Chrome Version | 132.0.6834.223 |
| Battery Health | 72% wear, 281 cycles - still kicking |
| Disk | 32GB eMMC storage, **8.6GB free** after optimization |
| Memory/Availability | 1.6GB free / 8.6GB available |
| Display | Integrated 1366x768 - humble, effective, and functional |
| OS Base | ChromeOS + Debian (Bookworm) via Crostini |
| Kernel | Linux 5.10+ (customized for ChromeOS) |
| DE/WM | None - Full CLI-first setup with Chromium browser (no Play Store, no Phone Hub) |
| CPU Load | 86% user / 12% system peak - and still going |

**Chrom-E** has an effectively built *air-gapped dev terminal* using:
- Sandboxed GPU memory
- CRAS audio system support
- Native WebGL render
- Crostini GPU acceleration
- CLI-driven clean-up and optimization
- Support for real-time audio analysis librariess (`librosa`, `matplotlib`)
- Machine learning pipelines (`scikit-learn`, `pandas`, `numpy`)
- Root-access terminal workflows

**Chrom-E** may be stripped of bloated corporate software such as VS Code, the Play Store, and standard GUI distractions, but he runs full-scale CLI workflows including real-time audio analysis, AI-driven workflows, full-stack applications, and ML-powered beat detection for high-performance music engines such as my music production software [AudioMIX](https://github.com/alexisvassquez/ai_spotibot_player).

The infamous **"Play Store Ghost"** effect isn't a bug - it's a feature. It represents a complete jailbreak from Google's consumer sandbox and a rebirth into a root-level dev terminal playground.

---

## 📜 Script Index (recurring updates)
- `chrom-e_cli_cleaner.sh` - Clear cache, remove stale logs, clean apt packages, temporary files, and find what's eating your storage.
- `memory_report.sh` - Visualize your memory, swap, and process usage.
- `disk_usage_report.sh` - Show top 20 space-hogging directories.
- `send_usage_summary.sh` - Generates a disk usage report, archives it, and emails an automated monthly report to recipient's configured address.
- `chrom-e_healthcheck.sh` - 💾 Full diagnostic report (RAM, CPU, load avg).
- `optimize_io.sh` - Boosts disk I/O performance with smart syncs and trim.
- `boost_cpu_governor.sh` - Backup your current CPU-freq governors, switch all cores to **performance** mode, and restore previous settings on demand.
- `audio_flush.sh` - Clears PulseAudio caches and resets audio pipeline.
- `chrom-e_help.sh` - Global project README and guide via CLI.
- `install_chrom-e.sh` - Installs `chrom-e` as a global help command.

### 🔐 Networking & Cybersecurity Utilities
- `network_trace.sh` - Shows current active connections + traceroute summary, performs reverse DNS + geoIP check, and flags suspicious connections.
- `check_listeners.sh` - Scans for *listening* ports, detects unknown services, and flags potential suspicious processes.

---

## 🛡️ Cybersecurity & Privacy Protection
**Chrom-E** isn't just here to clean and optimize - he's also your first line of defense. **Chrom-E's Power Toolkit** also contains new security scripts that help detect, trace, and shut down corporate telemetry, hidden backdoors, and rogue services in your container or Linux system. Defend your dev environment and keep your sandbox clean!

---

## 📚 Help Menu (quick reference)
Use `chrom-e_help.sh` or `chrom-e --help` to view:
- Script descriptions & usage
- Upcoming scripts in queue
- Pro tips for maintenance & system hygiene
- Bootles Wootles (your resident terminal guardian spirit who also automates your scripts in silent mode). To run:

```bash
chrom-e --bootles
```

This command does not optimize, clean, or diagnose. Instead, it **summons Bootles Wootles** - the mystical tuxedo cat spirit with a mustache who watches over your system. Bootles appears in glorious ASCII form and delivers a randomized cryptic message of purformance wisdowm.

Some say he's a daemon.
Some say he's a familiar.
Some say he once clawed the kernel and lived to tell the tale.

> Bootles Wootles was here. And your system has been purformed.

You may never truly understand him.
But if you run the command, he will understand **you.**

🪄 `chrom- --bootles`

---

## Requirements
- Bash (v4.0+ recommended)
- GNU Coreutils (`df`, `du`, `sort`, `grep`, etc.)
- `lsof` (for network tracing scripts)
- `sudo` privileges (for accurate `du` readings on system directories)
- `htop` (optional, for advanced process stats)
- `s-nail` (or a modern `mailx` implementation with SMTP support)
- `cron` (optional, for automated monthly reporting)

---

## Setup
- Clone the repo:
    ```bash
    git clone https://github.com/alexisvassquez/chrom-e_tools.git
    cd chrom-e_tools
    ```

- Make the scripts executable
    ```bash
    chmod +x <script_name>.sh`
    ```

### For Automated Monthly Email Reports
1. Configure your SMTP credentials in `~/.mailrc` (for automated monthly email reports in `send_usage_summary.sh`):
    ```bash
    set v15-compat
    set mta="smtp://your.email%40gmail.com:your_app_password@smtp.gmail.com:587"
    set from="your.email@gmail.com (Your Name)"
    ```

2. To run `send_usage_summary.sh` on the 1st of every month at 8:00 AM, add this line to your `crontab`:
   ```bash
   0 8 1 * * /home/your_username/chrom-e_tools/scripts/send_usage_summary.sh >> /home/your_username/chrom-e_log/cron.log 2>&1`
   ```

This will:
- Generate a disk usage report silently
- Email report to the configured address
- Archive it localled in `~/chrom-e_log/archive`

---

## License
MIT License
Copyright (c) and maintained by [Alexis M Vasquez](https://github.com/alexisvassquez), *Full-Stack Software Engineer, System Administrator, Coding Enthusiast.*
Permission is hereby granted, free of charge, to any person obtaining a copy.

> 🦾 Create Change Through Code.
