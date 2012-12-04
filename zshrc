# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster-light"

DEFAULT_USER="filippo"
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git svn vi-mode)
bindkey -v

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/cw:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/local/rvm/bin:/home/filippo/.rvm/bin
export LC_ALL="en_US.UTF-8"
export EDITOR="vim"

# modified commands
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias vi='vim'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'
alias google-chrome='google-chrome --disable-metrics --disable-hang-monitor --disable-dev-tools --disable-logging --memory-model=low --enable-accelerated-compositing "$@"'

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias pg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)
alias renetwork="sudo rc.d restart network; sudo rc.d restart wicd; sudo rc.d stop network"
alias regrub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias redate="sudo ntpdate ntp1.inrim.it"

# privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
    alias update='sudo pacman -Su'
    alias netcfg='sudo netcfg2'
fi

# ls
alias ls='ls -hF --color=auto --group-directories-first --time-style=+"%d.%m.%Y %H:%M"'
alias lr='ls -R'                    # recursive ls
alias ll='ls -al'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# pacman aliases (if applicable, replace 'pacman' with 'yaourt'/'pacaur'/whatever)
alias pacman="pacman-color"
alias pac="pacman -S"      # default action     - install one or more packages
alias pacu="pacman -Syu"   # '[u]pdate'         - upgrade all packages to their newest version
alias pacs="pacman -Ss"    # '[s]earch'         - search for a package using one or more keywords
alias paci="pacman -Si"    # '[i]nfo'           - show information about a package
alias pacr="pacman -R"     # '[r]emove'         - uninstall one or more packages
alias pacl="pacman -Sl"    # '[l]ist'           - list all packages of a repository
alias pacll="pacman -Qqm"  # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
alias paclo="pacman -Qdt"  # '[l]ist [o]rphans' - list all packages which are orphaned
alias paco="pacman -Qo"    # '[o]wner'          - determine which package owns a given file
alias pacf="pacman -Ql"    # '[f]iles'          - list all files installed by a given package
alias pacc="pacman -Sc"    # '[c]lean cache'    - delete all not currently installed package files
alias pacm="makepkg -fci"  # '[m]ake'           - make package from PKGBUILD file in current directory
alias yasu="yaourt -Syu --noconfirm --aur --color"

#colors
alias diff='colordiff'
alias grep='grep --color=auto'
alias df="dfc"
alias top="htop"
alias diff="colordiff"
alias svn="colorsvn"

#adb
alias adb="sudo /opt/android-sdk/platform-tools/adb kill-server;sudo /opt/android-sdk/platform-tools/adb"
alias acp="adb push"
alias abackup="adb backup -apk -shared -all -system -f ~/android-backup-$(date +\"%F\").ab"
alias arestore="adb restore $(ls -lrt | awk '/android-backup/ { f=$NF };END{ print f }')"

#sviluppo

replace() {
    find "$1" -name "$2" -type f -exec sed -i "s/$3/$4/g" {} \;
}
alias sst="svn st"
alias sup="svn up"
alias srm="svn rm"
alias smv="svn mv"
alias sci="svn ci -m"
alias sdiff="svn diff --force | diff"
alias srevertall="svn revert -R .; svn st | egrep -e \"^\?\" | awk '{ print \$2 }' | while read fileToAdd; do rm -rf \$fileToAdd; done"
alias saddall="svn st | egrep -e \"^\?\" | awk '{ print \$2 }' | while read fileToAdd; do svn add \$fileToAdd; done"

alias gst="git status"
alias gci="git commit -am "
alias gl="git pull; git submodule update"
alias gp="git push"
gcip() {
  gci "$@"; gp
}
alias grh="git reset HEAD"
alias gco="git checkout --"
alias grm="git rm"
alias gmv="git mv"
alias gdiff="git diff; git diff --cached"
alias glog="git lg"
alias gremote="git remote -v"

#onebip
alias ssh="ssh -tt"
alias onebip="~/create-ctags.sh; cd ~/Projects/onebip/subeng-ultimate"
alias start-onebip="sudo rc.d start sshd; sudo rc.d start jenkins; sudo rc.d start mongodb; sudo rc.d start httpd; onebip"
alias test="~/Projects/onebip/subeng-ultimate/script/test.sh"
alias tests="~/Projects/onebip/subeng-ultimate/script/tests.sh"

#paguro
alias paguro="cd /srv/http/wp-content/themes/paguroblu"
alias start-paguro="sudo rc.d start mysqld; sudo rc.d start httpd"

