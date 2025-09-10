#!/usr/bin/env bash

###############################################################################
# macOS Setup Script for Apple Silicon
# Installs Homebrew, apps, and applies customizations including Stage Manager
###############################################################################

# Ask for administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` timestamp until the script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Basic System Tweaks
###############################################################################

# Unhide ~/Library
chflags nohidden ~/Library

# Prevent system sleep when plugged in
sudo systemsetup -setcomputersleep Never

# Finder settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
killall Finder

# Dock settings
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock static-only -bool true
# Mission Control & Hot Corners
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock wvous-br-corner -int 4   # Desktop
defaults write com.apple.dock wvous-bl-corner -int 5   # Start screensaver
defaults write com.apple.dock wvous-tl-corner -int 2   # Mission Control
defaults write com.apple.dock wvous-tr-corner -int 12  # Notification Center
killall Dock

# Screenshots
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
killall SystemUIServer

# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable app launch quarantine dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Homebrew Installation & Updates
###############################################################################

# Check for Homebrew, install if missing
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully"
fi

# Add Homebrew to PATH (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Xcode Command Line Tools if missing
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools already installed!"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update
brew upgrade

###############################################################################
# Install Core Utilities & Packages
###############################################################################

brew install git
brew install htop
brew install micro
brew install wget
brew install yt-dlp
brew install tree
brew install mas
brew install jq
brew install go
brew install golangci-lint
brew install awscli
brew install ffmpeg
brew install make
brew install cmake
brew install postgresql
brew install python
brew install speedtest

# Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh && cd .. && rm -rf fonts

###############################################################################
# GUI Apps via Homebrew Casks
###############################################################################

brew install --cask visual-studio-code
brew install --cask slack
brew install --cask discord
brew install --cask java
brew install --cask private-internet-access
# brew install --cask adobe-creative-cloud   # personal only

###############################################################################
# Mac App Store Installs
###############################################################################

mas install 497799835   # Xcode
mas install 409201541   # Pages
mas install 409203825   # Numbers
mas install 409183694   # Keynote
mas install 504284434   # Other app

###############################################################################
# Stage Manager Customizations
###############################################################################

currentUser=$(ls -l /dev/console | awk '{print $3}')
currentUID=$(id -u "$currentUser")

# Enable Stage Manager
launchctl asuser $currentUID sudo -iu "$currentUser" defaults write com.apple.WindowManager GloballyEnabled -bool true

# Hide recent apps sidebar
launchctl asuser $currentUID sudo -iu "$currentUser" defaults write com.apple.WindowManager AutoHide -bool true

# Set window grouping to "One at a Time"
launchctl asuser $currentUID sudo -iu "$currentUser" defaults write com.apple.WindowManager AppWindowGroupingBehavior -bool true

# External display behavior: full desktop for stage strip
launchctl asuser $currentUID sudo -iu "$currentUser" defaults write com.apple.WindowManager StandardStageStripShowsFullDesktop -bool true

# Optional: refresh Finder to ensure desktop click behavior works
defaults write com.apple.finder CreateDesktop -bool true
killall Finder

###############################################################################
# Cleanup
###############################################################################

echo "Running brew cleanup..."
brew cleanup

echo "Setup complete!"
