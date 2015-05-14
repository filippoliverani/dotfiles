#!/bin/bash 
set -e

tee ~/.profile  << '
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
'

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

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install psutils
brew install git
brew install ruby
brew install python
brew install tmux
brew install the_silver_searcher
brew install vim --with-python --with-ruby --with-perl --env-std --override-system-vim
brew install boot2docker
brew install docker-compose
brew install caskroom/cask/brew-cask

#cask

CASK_OPTIONS='--appdir="/Applications"'
brew cask install $CASK_OPTIONS amethyst
brew cask install $CASK_OPTIONS caffeine
brew cask install $CASK_OPTIONS google-chrome
brew cask install $CASK_OPTIONS dropbox
brew cask install $CASK_OPTIONS flux
brew cask install $CASK_OPTIONS java
brew cask install $CASK_OPTIONS skype
brew cask install $CASK_OPTIONS calibre
brew cask install $CASK_OPTIONS google-drive
brew cask install $CASK_OPTIONS keepassx0
brew cask install $CASK_OPTIONS evernote
brew cask install $CASK_OPTIONS iterm2
brew cask install $CASK_OPTIONS the-unarchiver
brew cask install $CASK_OPTIONS vagrant
brew cask install $CASK_OPTIONS virtualbox
brew cask install $CASK_OPTIONS packer
brew cask install $CASK_OPTIONS atom

#powerline

pip install --upgrade pip
pip install --upgrade setuptools
pip install git+git://github.com/Lokaltog/powerline
pip install psutil

mkdir -p ~/.config/powerline
cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/** ~/.config/powerline
sudo mkdir -p /usr/share/tmux
sudo ln -s /usr/local/lib/python2.7/site-packages/powerline/bindings/tmux/powerline.conf /usr/share/tmux/powerline.conf
