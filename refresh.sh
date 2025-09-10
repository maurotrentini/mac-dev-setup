#!/usr/bin/env bash
set -e

echo "🔄 Smart Refresh Script Starting..."

# 1️⃣ Update Homebrew itself
echo "🍺 Updating Homebrew..."
brew update

# Arrays to track status
INSTALLED=()
UPGRADED=()
UP_TO_DATE=()

# 2️⃣ Upgrade installed formulae and track upgrades
echo "⬆️ Checking for formula updates..."
for formula in $(brew list --formula); do
    if brew outdated --formula | grep -q "^$formula$"; then
        brew upgrade "$formula"
        UPGRADED+=("$formula")
    else
        UP_TO_DATE+=("$formula")
    fi
done

# 3️⃣ Install missing formulae from Brewfile
echo "📦 Installing missing formulae..."
for pkg in $(grep '^brew' Brewfile | awk '{print $2}' | tr -d '"'); do
    if ! brew list --formula | grep -q "^$pkg$"; then
        brew install "$pkg"
        INSTALLED+=("$pkg")
    fi
done

# 4️⃣ Upgrade / install casks and track status
echo "📦 Checking GUI apps (casks)..."
for cask in $(grep '^cask' Brewfile | awk '{print $2}' | tr -d '"'); do
    if ! brew list --cask | grep -q "^$cask$"; then
        brew install --cask "$cask"
        INSTALLED+=("$cask")
    elif brew outdated --cask | grep -q "^$cask$"; then
        brew upgrade --cask "$cask"
        UPGRADED+=("$cask")
    else
        UP_TO_DATE+=("$cask")
    fi
done

# 5️⃣ (Optional) Uncomment to remove apps not in Brewfile
brew bundle cleanup --file=./Brewfile --force

# 6️⃣ Refresh Dock
echo "🛠 Refreshing Dock layout..."
dockutil --remove all --no-restart

# System & default apps
dockutil --add "/System/Applications/System Settings.app" --no-restart
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
dockutil --add "/Applications/Docker.app" --no-restart
dockutil --add "/Applications/Tailscale.app" --no-restart
killall Dock

# 7️⃣ Summary
echo ""
echo "📊 Refresh Summary:"
echo "✅ Installed: ${INSTALLED[*]:-None}"
echo "⬆️ Upgraded: ${UPGRADED[*]:-None}"
echo "✔️ Already up-to-date: ${UP_TO_DATE[*]:-None}"
echo ""
echo "✅ Smart refresh complete!"

