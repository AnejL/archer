#!/bin/bash
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	exit 1
fi

# Helper functions 
#
# function for asking user something
function prompt() {
	echo -e "\n"
	read -p "$1 [y/n] " -n 1 -r
}

loadkeys slovene

# if efivars is a directory
if [ -d /sys/firmware/efi/efivars ]; then

fi

# TODO connect to the internets

timedatectl set-ntp true

prompt "Do you want to format disks with fdisk?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	lsblk
fi

# which partition is the right one?
# mount the partition(s) to mnt

pacstrap /mnt base base-devel linux linux-firmare linux-headers networkmanager neovim

genfstab -U /mnt >> /mnt/etc/fstab

echo "arch-chroot /mnt"
