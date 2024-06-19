#!/bin/bash

mount -o subvol=@ /dev/nvme0n1p2 /mnt
mount -o subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o subvol=@log /dev/nvme0n1p2 /mnt/var/log
mount -o subvol=@pkg /dev/nvme0n1p2 /mnt/var/cache/pacman/pkg
mount -o subvol=@.snapshots /dev/nvme0n1p2 /mnt/.snapshots

mount /dev/nvme0n1p1 /mnt/boot

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

echo "Subvolumes mounted, chrooting..."
arch-chroot /mnt
