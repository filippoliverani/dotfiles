#!/bin/bash

cd /home/filippo

#packages

tee -a /etc/pacman.conf <<< "
[archlinuxfr]
SigLevel = Optional
Server = http://repo.archlinux.fr/\$arch"

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 mirrorlist.backup > mirrorlist
rm /etc/pacman.d/mirrorlist.backup

pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys
pacman --noconfirm -Syu
pacman --noconfirm -S sudo yaourt

tee -a /etc/sudoers <<< "
filippo ALL=(ALL) ALL"

su filippo

yaourt --noconfirm -Syu
yaourt --noconfirm -S \
  base-devel pacman-color openssh openssl tmux unrar unzip zsh \
  cups parted bash-completion subversion git dstat iotop \
  colordiff colorsvn dfc cdu \
  wicd wicd-gtk dhclient \
  virtualbox virtualbox-host-modules virtualbox-guest-iso virtualbox-ext-oracle\
  android-sdk-platform-tools php ruby vagrant \
  alsa-lib alsa-oss alsa-utils gstreamer0.10-plugins gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins \
  xorg-server xorg-apps xorg-xinit xorg-server-utils xf86-video-nouveau xf86-video-intel xf86-video-ati xf86-input-synaptics \
  slim archlinux-themes-slim xfce4 xfce4-goodies xfce4-screenshooter xfce4-mixer thunar-volman gvfs \
  xfwm-axiom-theme zukitwo-themes faenza-icon-theme faenza-xfce-addon ttf-dejavu artwiz-fonts xcursor-vanilla-dmz \
  inkscape gimp gcolor2 google-chrome profile-sync-daemon keepassx kupfer gksu gvim leafpad audacious skype xfmedia hotot-gtk3

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
sudo tee -a /etc/psd.conf <<< 'BROWSERS="google-chrome"'
systemctl enable psd.service psd-resync.service

#virtualbox

sudo gpasswd -a filippo vboxusers
sudo tee /etc/modules-load.d/virtualbox.conf <<< "vboxdrv"
sudo modprobe vboxdrv

#ruby

tee /etc/gemrc <<< "
gem: --no-ri --no-rdoc"
sudo gem update --system

sudo chown -R filippo.users /home/filippo
