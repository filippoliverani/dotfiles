#!/bin/bash

cd /home/filippo

#pacman

sudo tee -a /etc/pacman.conf <<< "
[archlinuxfr]
Server = http://repo.archlinux.fr/$arch"

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.backup
sudo rankmirrors -n 6 mirrorlist.backup > mirrorlist
sudo rm /etc/pacman.d/mirrorlist.backup

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -Syu
sudo pacman -S package-query pacman-color yaourt

yaourt --noconfirm -Syu
yaourt --noconfirm -S ack audacious android-sdk-platform-tools artwiz-fonts bash-completion colordiff colorsvn cups dfc cdu dropbox dstat iotop inkscape gimp git gcolor2 google-chrome-stable gksu gvim keepassx kupfer openssh openssl php parted ruby slim archlinux-themes-slim subversion ttf-dejavu tmux unrar unzip virtualbox virtualbox-host-modules virtualbox-guest-iso virtualbox-ext-oracle xfce4 xfce4-goodies xfce4-screenshooter xfce4-mixer xfwm-axiom-theme xfce-theme-greybird faenza-icon-theme faenza-xfce-addon alsa-lib alsa-oss alsa-utils gstreamer0.10-plugins gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins wicd wicd-gtk dhclient xorg-server xorg-apps xorg-xinit xorg-server-utils xf86-video-nouveau xf86-video-intel xf86-video-ati xf86-input-synaptics xcursor-themes xcursor-vanilla-dmz monaco-linux-font thunar-volman gvfs skype xfmedia zsh profile-sync-daemon

sudo gpasswd -a filippo network
sudo systemctl enable wicd.service
sudo systemctl enable slim.service

#performance

sudo tee -a /etc/sysctl.conf <<< "
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
vm.vfs_cache_pressure = 50
vm.laptop_mode = 1
vm.swappiness = 10
kernel.shmmax=17179869184
kernel.shmall=4194304
fs.inotify.max_user_watches = 524288"

#zsh

chsh -s $(which zsh)

#x

sudo sed -i 's/#x:5:respawn:\/usr\/bin\/slim\//x:5:respawn:\/usr\/bin\/slim\/' /etc/inittab
sudo tee -a /home/filippo/.xinitrc <<< "exec startxfce4"

#psd

sudo sed -i 's/USERS=""/USERS="filippo"/' /etc/psd.conf
sudo sed -i 's/BROWSERS=""/BROWSERS="google-chrome"/' /etc/psd.conf
sudo systemctl enable psd.service

#virtualbox

sudo gpasswd -a filippo vboxusers
sudo tee /etc/modules-load.d/virtualbox.conf <<< "vboxdrv"
sudo modprobe vboxdrv

#ruby

sudo rm /etc/gemrc
sudo touch /etc/gemrc
sudo gem update --system

#dotfiles

curl https://raw.github.com/filippo-liverani/dotfiles/master/bootstrap -L -o - | sh
