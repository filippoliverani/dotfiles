#!/bin/bash

set -e

if (( EUID != 0 )); then
   echo "You must be root to do this." 1>&2
   exit 100
fi

username='filippo'

#user

useradd -m -g users -G wheel -s /bin/bash $username
chown -R $username /home/$username

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
pacman --noconfirm -S sudo yaourt powerpill

sed "s|/usr/bin/pacman|/usr/bin/yaourt|" -i /etc/powerpill/powerpill.json

tee -a /etc/sudoers <<< "
$username ALL=(ALL) ALL"

BASE_PACKAGES="pacmatic linux-lts base-devel openssh openssl unrar unzip zsh nfs-utils atool \
               cups parted git htop colordiff dfc cdu wicd dhclient b43-firmware ranger python-powerline-git \
               alsa-lib alsa-oss alsa-utils lib32-alsa-lib pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins \
               gstreamer0.10-plugins gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins \
               xorg-server xorg-apps xorg-xinit xorg-server-utils xf86-video-nouveau xf86-video-intel xf86-video-ati xf86-input-synaptics xclip \
               slim slim-themes archlinux-themes-slim \
               zukitwo-themes faenza-icon-theme ttf-dejavu artwiz-fonts xcursor-vanilla-dmz lib32-gtk2 \
               remmina wicd-gtk pavucontrol keepassx simple-scan inkscape gimp gcolor3 gvim leafpad skype dropbox grive \
               chromium freerdp google-talkplugin chromium-pepper-flash-stable"
XFCE_PACKAGES="xfce4 xfce4-goodies xfce4-screenshooter xfce4-mixer faenza-xfce-addon \
               thunar-volman gvfs gvfs-smb gksu file-roller kupfer evince parole"
I3_PACAKGES="i3 dmenu-xft feh lxappearance xfce4-terminal apvlv udisks2 mplayer cmus"
DEV_PACKAGES="tmux ruby ruby-tmuxinator wemux-git packer-io vagrant dstat iotop the_silver_searcher subversion eclipse \
              virtualbox virtualbox-host-modules virtualbox-guest-iso virtualbox-ext-oracle"

su - $username -c "yaourt --noconfirm -Syu"
su - $username -c "yaourt --noconfirm -S $BASE_PACKAGES"
while test $# -gt 0
do
    case "$1" in
        dev)
            su - $username -c "yaourt --noconfirm -S $DEV_PACKAGES"
            DEV=true
            ;;
        xfce)
            su - $username -c "yaourt --noconfirm -S $XFCE_PACKAGES"
            ;;
        i3)
            su - $username -c "yaourt --noconfirm -S $I3_PACKAGES"
            ;;
    esac
    shift
done

#ssh

systemctl enable sshd.service
systemctl start sshd.service

#wicd

gpasswd -a $username network
systemctl enable wicd.service
systemctl start wicd.service

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

chsh -s $(which zsh) $username

#nfs

systectl enable rpc-idmapd.service
systectl start rpc-idmapd.service
systectl enable rpc-mountd.service
systectl start rpc-mountd.service

#slim

tee -a /etc/slim.conf <<< "
  default_user $username
  auto_login yes"
systemctl enable slim.service

#powerline

mkdir -p /home/$username/.config/powerline
cp -R /usr/lib/python3.3/site-packages/powerline/config_files/** /home/$username/.config/powerline

if [ "$DEV" ]
  then
    #virtualbox

    gpasswd -a $username vboxusers
    tee /etc/modules-load.d/virtualbox.conf <<< "
      vboxdrv
      vboxnetadp
      vboxnetflt"
    sudo modprobe -a vboxdrv vboxnetadp vboxnetflt

    #ruby

    tee /etc/gemrc <<< "
    gem: --no-ri --no-rdoc"
    gem update --system

    #vagrant

    vagrant plugin install vagrant-windows vagrant-vbguest
fi

