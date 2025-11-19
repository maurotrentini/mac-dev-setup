#!/usr/bin/env bash
set -e

echo "🚀 Starting full setup..."

# Arrays to track status
INSTALLED=()
SKIPPED=()

# 1️⃣ Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  INSTALLED+=("Homebrew")
else
  echo "✅ Homebrew already installed"
fi

# 2️⃣ Update Homebrew
echo "🍺 Updating Homebrew..."
brew update

# 3️⃣ Install formulae from Brewfile
echo "📦 Installing formulae..."
for pkg in $(grep '^brew' Brewfile | awk '{print $2}' | tr -d '"'); do
    if ! brew list --formula | grep -q "^$pkg$"; then
        brew install "$pkg"
        INSTALLED+=("$pkg")
    else
        SKIPPED+=("$pkg")
    fi
done

# 4️⃣ Install casks from Brewfile
echo "📦 Installing GUI apps (casks)..."
for cask in $(grep '^cask' Brewfile | grep -v '^#' | awk '{print $2}' | tr -d '"'); do
    if ! brew list --cask | grep -q "^$cask$"; then
        brew install --cask "$cask"
        INSTALLED+=("$cask")
    else
        SKIPPED+=("$cask")
    fi
done

# 5️⃣ Ensure dockutil is installed
if ! command -v dockutil &>/dev/null; then
    echo "Installing dockutil..."
    brew install dockutil
fi

# 6️⃣ Dock setup
echo "🛠 Configuring Dock..."
dockutil --remove all --no-restart

# System & default apps
dockutil --add "/System/Applications/System Settings.app" --no-restart
dockutil --add "/System/Applications/Passwords.app" --no-restart
dockutil --add "/System/Applications/App Store.app" --no-restart

# Developer / work apps
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/Applications/Arc.app" --no-restart
dockutil --add "/Applications/iTerm.app" --no-restart
dockutil --add "/Applications/Sublime Text.app" --no-restart
dockutil --add "/Applications/Postman.app" --no-restart
dockutil --add "/Applications/Sequel Ace.app" --no-restart
dockutil --add "/Applications/Visual Studio Code.app" --no-restart
dockutil --add "/Applications/Slack.app" --no-restart
# dockutil --add "/Applications/Microsoft Teams.app" --no-restart
dockutil --add "/Applications/Cursor.app" --no-restart
dockutil --add "/Applications/Kiro.app" --no-restart
dockutil --add "/Applications/ChatGPT.app" --no-restart
dockutil --add "/Applications/WhatsApp.app" --no-restart
dockutil --add "/Applications/Docker.app" --no-restart
dockutil --add "/Applications/Tailscale.app" --no-restart
killall Dock

# 7️⃣ Summary
echo ""
echo "📊 Setup Summary:"
echo "✅ Installed: ${INSTALLED[*]:-None}"
echo "⏭️ Already installed: ${SKIPPED[*]:-None}"
echo ""
echo "✅ Setup complete!"

