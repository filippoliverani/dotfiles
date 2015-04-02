#!/bin/bash 
set -e

tee ~/.profile  << '
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
'

# config

defaults write com.apple.finder AppleShowAllFiles TRUE
defaults write com.apple.finder _FXShowPosixPathInTitle TRUE
defaults write com.apple.Finder QuitMenuItem TRUE

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
brew install caskroom/cask/brew-cask

#cask

brew cask install amethyst
brew cask install caffeine
brew cask install google-chrome
brew cask install dropbox
brew cask install flux
brew cask install java
brew cask install skype
brew cask install the-unarchiver
brew cask install vagrant
brew cask install virtualbox

#powerline

pip install git+git://github.com/Lokaltog/powerline
pip install psutil

mkdir -p ~/.config/powerline
cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/** ~/.config/powerline
sudo mkdir -p /usr/share/tmux
sudo ln -s /usr/local/lib/python2.7/site-packages/powerline/bindings/tmux/powerline.conf /usr/share/tmux/powerline.conf
