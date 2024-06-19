#!/bin/bash

mount -o subvol=@ /dev/nvme0n1p2 /mnt
mount -o subvol=@home /dev/nvme0n1p2 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
mount -o subvol=@.snapshots /dev/nvme0n1p2 /mnt/.snapshots
mkdir -p /mnt/timeshift-btrfs/snapshots/
mount timeshift-btrfs/snapshots /dev/nvme0n1p2 /mnt/timeshift-btrfs/snapshots

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
