#!/bin/bash

set -e

tee ~/.profile  << '
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
'

#brew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install psutils
brew install git
brew install ruby
brew install python
brew install tmux
brew install caskroom/cask/brew-cask

#cask

brew cask install amethyst
brew cask install caffeine
brew cask install google-chrome
brew cask install dropbox
brew cask install flux
brew cask install macvim
brew cask install java
brew cask install skype
brew cask install the-unarchiver
brew cask install vagrant
brew cask install virtualbox

tee ~/Library/Application Support/Chromium/Default <<< '
CHROMIUM_FLAGS="--reset-variation-state --disk-cache-dir=/tmp/chromium-cache --disable-metrics --disable-hang-monitor --disable-dev-tools --disable-logging --disable-plugins-discovery --disable-translate --no-experiments --no-pings --no-referrers --memory-model=low --enable-accelerated-compositing --ignore-gpu-blacklist"
'

#powerline

pip install git+git://github.com/Lokaltog/powerline

mkdir -p ~/.config/powerline
cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/** ~/.config/powerline
