#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

chflags nohidden ~/Library

# Show Hidden Files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true



# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew installed successfully"
else
    echo "Homebrew already installed!"
fi

# Install XCode Command Line Tools
echo 'Checking to see if XCode Command Line Tools are installed...'
brew config

# Updating Homebrew.
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae.
echo "Upgrading Homebrew..."
brew upgrade



# Install Git
echo "Installing Git..."
brew install git

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git
cd fonts || exit
sh -c ./install.sh

cd 

# Install other useful binaries.
brew install speedtest_cli


# Development tool casks
brew install --cask --appdir="/Applications" visual-studio-code

# Misc casks
brew install --cask --appdir="/Applications" slack


brew install go
brew install golangci-lint
brew install htop
brew install micro
brew install wget
brew install link
brew install youtube-dl
brew install tree
brew install mas
brew install jq
brew install --cask discord
brew install awscli
brew install ffmpeg
brew install ffprobe
#brew install nmap 
#brew install amass
brew install make
brew install cmake
brew install postgresql
brew install --cask java
brew install python
brew install --cask private-internet-access

# personal only 
# brew install --cask adobe-creative-cloud


mas install 497799835 
mas install 409201541
mas install 409203825 
mas install 409183694 
mas install 504284434

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock

defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui dndStart -integer 1
defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui dndEnd -integer 0
killall NotificationCenter


#wget https://github.com/glouel/AerialCompanion/releases/latest/download/AerialCompanion.dmg
#wget https://discord.com/api/download?platform=osx


echo "Running brew cleanup..."
brew cleanup





