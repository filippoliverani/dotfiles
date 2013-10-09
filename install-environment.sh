#!/bin/bash

set -e

if (( EUID != 0 )); then
   echo "You must be root to do this." 1>&2
   exit 100
fi

cd /home/filippo

#packages

dhcpcd

tee -a /etc/pacman.conf <<< "
[archlinuxfr]
SigLevel = Optional
Server = http://repo.archlinux.fr/\$arch"

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.backup

pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys
pacman --noconfirm -Syu
pacman --noconfirm -S sudo yaourt

tee -a /etc/sudoers <<< "
filippo ALL=(ALL) ALL"


su - filippo -c 'yaourt --noconfirm -Syu'
su - filippo -c 'yaourt --noconfirm -S \
  pacmatic linux-lts base-devel openssh openssl tmux ruby-tmuxinator wemux-git unrar unzip zsh \
  cups parted bash-completion subversion git dstat iotop the_silver_searcher \
  colordiff colorsvn dfc cdu \
  wicd wicd-gtk dhclient b43-firmware\
  virtualbox virtualbox-host-modules virtualbox-guest-iso virtualbox-ext-oracle\
  android-sdk-platform-tools php ruby vagrant \
  alsa-lib alsa-oss alsa-utils lib32-alsa-lib pulseaudio pavucontrol pulseaudio-alsa lib32-libpulse lib32-alsa-plugins\
  gstreamer0.10-plugins gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins \
  xorg-server xorg-apps xorg-xinit xorg-server-utils xf86-video-nouveau xf86-video-intel xf86-video-ati xf86-input-synaptics \
  slim slim-themes archlinux-themes-slim xfce4 xfce4-goodies xfce4-screenshooter xfce4-mixer thunar-volman gvfs gksu file-roller \
  zukitwo-themes faenza-icon-theme faenza-xfce-addon ttf-dejavu artwiz-fonts xcursor-vanilla-dmz lib32-gtk2 \
  inkscape gimp gcolor2 google-chrome google-talkplugin keepassx kupfer gvim leafpad parole skype hotot-gtk3 simple-scan'

gpasswd -a filippo network
systemctl enable wicd.service
systemctl enable slim.service

#pacman

tee -a /etc/yaourtrc <<< 'PACMAN="pacmatic"'

#performance

tee -a /etc/sysctl.d/99-sysctl.conf <<< "
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

sed -i 's/#x:5:respawn:\/usr\/bin\/slim\//x:5:respawn:\/usr\/bin\/slim\/' /etc/inittab
tee -a /home/filippo/.xinitrc <<< "exec startxfce4"

#slim

tee -a /etc/slim.conf <<< "
default_user filippo
auto_login yes"

#virtualbox

gpasswd -a filippo vboxusers
tee /etc/modules-load.d/virtualbox.conf <<< "vboxdrv"
modprobe vboxdrv

#ruby

tee /etc/gemrc <<< "
gem: --no-ri --no-rdoc"
gem update --system

chown -R filippo.users /home/filippo
