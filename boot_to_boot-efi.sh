#!/bin/bash

echo "\n\nClearing /boot/..."
rm -rf /boot/*

echo "\n\nUnmounting /boot/..."
umount /boot

echo "\n\nInstalling linux kernel and generating images..."
pacman -Sy linux

echo "\n\nDetermining system details..."
if grep -q 'GenuineIntel' /proc/cpuinfo; then
    echo "The system is running on an Intel processor. Installing intel-ucode..."
	pacman -Sy intel-ucode
elif grep -q 'AuthenticAMD' /proc/cpuinfo; then
    echo "The system is running on an AMD processor. Installing amd-ucode..."
	pacman -Sy amd-ucode
else
    echo "The system's processor is neither Intel nor AMD."
fi

echo "\n\nMounting /boot/efi..."
mkdir /boot/efi

echo "\n\nEditing /etc/fstab..."
sed -i 's/\/boot/\/boot\/efi/g' /etc/fstab

echo "\n\nReloading systemctl daemons to use the updated /etc/fstab..."
systemctl daemon-reload

echo "\n\nFinding path for ESP device..."
ESP=$(awk '/\/boot/ {print substr(prev, 3); exit} {prev=$0}' /etc/fstab)
echo "\nFound ESP device as $ESP"

echo "\n\nMounting ESP device..."
mount $ESP /boot/efi

echo "\n\nInstalling grub..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

echo "\n\nCreating grub config..."
grub-mkconfig -o /boot/grub/grub.cfg
