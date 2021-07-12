#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Xfce4 UI components"
apt-get update 
apt-get install -y supervisor xfce4 xfce4-terminal xterm
apt-get purge -y pm-utils xscreensaver*
apt-get clean -y
apt-get install ubuntu-drivers-common \
  && sudo ubuntu-drivers autoinstall

#comment out the above if you want to modify the version you get and uncomment the below to select during install:
#install with sudo ubuntu-drivers install <package version>

#sudo ubuntu-drivers devices

#blacklist the Nouveau driver so it doesn't initialize:
bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sleep 1
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
sleep 1
clear

#update the kernel to reflect changes:
echo "updating initramfs..."
sleep 1
sudo update-initramfs -u
clear

#end of script output
echo "Script completed - NVIDIA drivers installed"
echo "please restart your machine to initialize correctly"
