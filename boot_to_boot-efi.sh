#!/bin/bash

read -p "Please enter the desired ESP directory (default /boot/efi/): " ESP_RAW
if [ -z "$ESP_RAW" ]; then
    ESP="/boot/efi"
else
    ESP=$(echo "$ESP_RAW" | sed 's/^ *//; s/ *$//')
fi

echo -e "\n\nClearing /boot/..."
rm -rf /boot/*

echo -e "\n\nUnmounting /boot/..."
umount /boot

# Ask if the user wants any additional kernels
echo -e "\n\n"
read -p "Please enter any additional linux kernels you would like to install, separated by a space: " KERNELS
if [ -z "$KERNELS" ]; then
    echo -e "\n\nInstalling linux kernel and generating images..."
    pacman -Sy --noconfirm linux linux-headers
else
    HEADERS=""
    for kernel in $KERNELS; do
        HEADERS+="$kernel-headers "
    done
    echo -e "\n\nInstalling linux kernel and $KERNELS and generating images..."
    pacman -Sy --noconfirm linux linux-headers $KERNELS $HEADERS
fi

echo -e "\n\nDetermining system details..."
if grep -q 'GenuineIntel' /proc/cpuinfo; then
    echo "The system is running on an Intel processor. Installing intel-ucode..."
	pacman -Sy --noconfirm intel-ucode
elif grep -q 'AuthenticAMD' /proc/cpuinfo; then
    echo "The system is running on an AMD processor. Installing amd-ucode..."
	pacman -Sy --noconfirm amd-ucode
else
    echo "The system's processor is neither Intel nor AMD."
fi

echo -e "\n\nCreating $ESP..."
mkdir -p $ESP

echo -e "\n\nEditing /etc/fstab..."
ESCAPED_ESP=$(echo "$ESP" | sed 's/\//\\\//g')
sed -i "s/\/boot/$ESCAPED_ESP/g" /etc/fstab

echo -e "\n\nReloading systemctl daemons to use the updated /etc/fstab..."
systemctl daemon-reload

echo -e "\n\nMounting ESP device..."
mount -av

echo -e "\n\nInstalling grub..."
grub-install --target=x86_64-efi --efi-directory=$ESP --bootloader-id=grub

echo -e "\n\nCreating grub config..."
grub-mkconfig -o /boot/grub/grub.cfg
