# MacBook Dev Setup

This repository contains scripts to bootstrap and maintain my development environment on macOS.  
It automates the installation of command-line tools, apps, and utilities using [Homebrew](https://brew.sh/) and keeps my Dock organized.

## 📦 What’s Included
- **setup.sh** – Full one-time setup for a fresh Mac:
  - Installs Homebrew (if missing)
  - Installs CLI tools and GUI apps defined in `Brewfile`
  - Configures the Dock layout
- **refresh.sh** – Safe re-run script for daily/weekly maintenance:
  - Updates Homebrew & installed apps
  - Reinstalls anything missing from `Brewfile`
  - Optionally (commented out) removes apps not listed in `Brewfile`
  - Resets & reconfigures the Dock
- **Brewfile** – Single source of truth for installed apps/tools

## 🚀 Quick Start

Clone the repo:
```bash
git clone https://github.com/maurotrentini/mac-dev-setup.git
cd mac-dev-setup
