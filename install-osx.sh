#!/bin/bash
set -e

echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' > ~/.profile

# config

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.Finder QuitMenuItem -bool true
defaults write com.apple.finder CreateDesktop -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder QLEnableTextSelection -bool true

defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleFontSmoothing -int 2
defaults write NSGlobalDomain KeyRepeat -int 0

defaults write com.apple.LaunchServices LSQuarantine -bool false

defaults write com.apple.dock no-glass -bool true
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 1

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.universalaccess reduceTransparency -bool true
defaults write com.apple.BezelServices kDimTime -int 300

defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

killall Finder
killall Dock
killall SystemUIServer

sudo pmset -a sms 0
hash tmutil &> /dev/null && sudo tmutil disablelocal

#brew
export HOMEBREW_NO_ANALYTICS=1

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
xcode-select --install
brew doctor

brew install psutils
brew install dfc
brew install git
brew install ruby
brew install python
brew install php57
brew install racket
brew install npm
brew install tmux
brew install reattach-to-user-namespace
brew install tree
brew install ranger
brew install the_silver_searcher
brew install vim --with-python --with-ruby --with-perl --env-std --override-system-vim
brew install packer
brew install caskroom/cask/brew-cask

#cask
brew cask install --appdir="/Applications" --force google-chrome
brew cask install --appdir="/Applications" --force alfred
brew cask install --appdir="/Applications" --force caffeine
brew cask install --appdir="/Applications" --force cyberduck
brew cask install --appdir="/Applications" --force pomodone
brew cask install --appdir="/Applications" --force monolingual
brew cask install --appdir="/Applications" --force tunnelblick
brew cask install --appdir="/Applications" --force google-drive
brew cask install --appdir="/Applications" --force skype
brew cask install --appdir="/Applications" --force calibre
brew cask install --appdir="/Applications" --force iterm2
brew cask install --appdir="/Applications" --force the-unarchiver
brew cask install --appdir="/Applications" --force chefdk
brew cask install --appdir="/Applications" --force vagrant
brew cask install --appdir="/Applications" --force atom
brew cask install --appdir="/Applications" --force virtualbox
brew cask install --appdir="/Applications" --force gimp
brew cask install --appdir="/Applications" --force inkscape
brew cask install --appdir="/Applications" --force postman
brew cask install --appdir="/Applications" --force docker

#scheme

raco pkg install --auto --scope installation --skip-installed berkeley xrepl

#powerline

pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade psutil
pip install --upgrade powerline-status

mkdir -p ~/.config/powerline
cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/** ~/.config/powerline
