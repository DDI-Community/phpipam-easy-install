# phpIPAM Easy Install - Future Ideas & Enhancements

## General Improvements
- Add auto-detection of Debian version
- Add `set -euo pipefail` for safer Bash scripting
- Auto-generate random MariaDB password if not provided
- Optional: Load variables from `.env` file

## Features
- Optional SSL via Let's Encrypt
- Auto-hardening MariaDB (remove test DB, disable remote root login)
- Optional SNMP / fping discovery install
- Systemd service status check after install
- Automated firewall rules for phpIPAM access

## Repository Improvements
- Add LICENSE file
- Add CHANGELOG.md
- Add CONTRIBUTING.md for pull requests

## Automation
- GitHub Actions to test the install script automatically
- Prepare Docker-based installer (optional)
- Prepare LXC template for Proxmox/containers

## Documentation
- Troubleshooting section
- Recommended PHP settings for bigger environments
- Guide for updating phpIPAM to a new version
