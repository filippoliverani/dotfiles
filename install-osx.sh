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
killall Finder

defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleFontSmoothing -int 2
defaults write NSGlobalDomain KeyRepeat -int 0

defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

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

brew cask install --appdir="/Applications" amethyst
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" java
brew cask install --appdir="/Applications" skype
brew cask install --appdir="/Applications" calibre
brew cask install --appdir="/Applications" google-drive
brew cask install --appdir="/Applications" iterm2
brew cask install --appdir="/Applications" the-unarchiver
brew cask install --appdir="/Applications" vagrant
brew cask install --appdir="/Applications" virtualbox
brew cask install --appdir="/Applications" packer

#powerline

pip install git+git://github.com/Lokaltog/powerline
pip install psutil

mkdir -p ~/.config/powerline
cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/** ~/.config/powerline
sudo mkdir -p /usr/share/tmux
sudo ln -s /usr/local/lib/python2.7/site-packages/powerline/bindings/tmux/powerline.conf /usr/share/tmux/powerline.conf
