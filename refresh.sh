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

# 6️⃣ Ensure dockutil is installed
if ! command -v dockutil &>/dev/null; then
    echo "Installing dockutil..."
    brew install dockutil
fi

# 7️⃣ Refresh Dock
echo "🛠 Refreshing Dock layout..."
dockutil --remove all --no-restart

# Apple communication & device apps
dockutil --add "/System/Applications/iPhone Mirroring.app" --no-restart
dockutil --add "/System/Applications/Messages.app" --no-restart
dockutil --add "/System/Applications/FaceTime.app" --no-restart
dockutil --add "/System/Applications/Phone.app" --no-restart

# Third-party messaging
dockutil --add "/Applications/WhatsApp.app" --no-restart
dockutil --add "/Applications/Telegram.app" --no-restart

# Productivity & personal info
dockutil --add "/System/Applications/Calendar.app" --no-restart
dockutil --add "/System/Applications/Contacts.app" --no-restart
dockutil --add "/System/Applications/Reminders.app" --no-restart
dockutil --add "/System/Applications/Notes.app" --no-restart
dockutil --add "/System/Applications/Photos.app" --no-restart

# Browser & AI
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/Applications/ChatGPT.app" --no-restart

# System
dockutil --add "/System/Applications/App Store.app" --no-restart
dockutil --add "/System/Applications/Passwords.app" --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart
killall Dock

# 8️⃣ Summary
echo ""
echo "📊 Refresh Summary:"
echo "✅ Installed: ${INSTALLED[*]:-None}"
echo "⬆️ Upgraded: ${UPGRADED[*]:-None}"
echo "✔️ Already up-to-date: ${UP_TO_DATE[*]:-None}"
echo ""
echo "✅ Smart refresh complete!"

