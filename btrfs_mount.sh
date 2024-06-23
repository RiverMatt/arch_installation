#!/bin/bash

read -p "Enter the path for the boot device (/dev/nvme0n1p1): " BOOT_PARTITION
read -p "Enter the mount point for the boot device (/mnt/boot or /mnt/boot/efi): " BOOT_MNT_POINT

mount -o subvol=@ /dev/nvme0n1p2 /mnt
mount -o subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o subvol=@log /dev/nvme0n1p2 /mnt/var/log
mount -o subvol=@pkg /dev/nvme0n1p2 /mnt/var/cache/pacman/pkg
mount -o subvol=@.snapshots /dev/nvme0n1p2 /mnt/.snapshots

mount $BOOT_PARTITION $BOOT_MNT_POINT

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

echo "Subvolumes mounted, chrooting..."
arch-chroot /mnt
