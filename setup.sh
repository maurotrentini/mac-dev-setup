#!/usr/bin/env bash
set -e

echo "🚀 Starting full setup..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update and install from Brewfile
echo "📦 Installing apps from Brewfile..."
brew bundle --file=./Brewfile

# Ensure dockutil is installed
if ! command -v dockutil &>/dev/null; then
    echo "Installing dockutil..."
    brew install dockutil
fi

# Dock setup
echo "🧹 Resetting and configuring Dock..."
dockutil --remove all --no-restart

# Core system apps
dockutil --add "/System/Applications/System Settings.app" --no-restart
dockutil --add "/System/Applications/App Store.app" --no-restart

# User apps from Brewfile
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/Applications/iTerm.app" --no-restart
dockutil --add "/Applications/Sublime Text.app" --no-restart
dockutil --add "/Applications/Postman.app" --no-restart
dockutil --add "/Applications/WhatsApp.app" --no-restart
dockutil --add "/Applications/Visual Studio Code.app" --no-restart
dockutil --add "/Applications/Slack.app" --no-restart
dockutil --add "/Applications/zoom.us.app" --no-restart

# Restart Dock
killall Dock

echo "✅ Setup complete!"

