`timeshift-pre-pacman.hook` goes in `/etc/pacman.d/hooks/`

After installing, the default ESP mount point will be `/boot`. We don't want that, because BTRFS will not see the kernel images and that causes problems later. Here's how to move the ESP to `/boot/efi` and store your kernel images in `/boot`

1. Delete everything in `/boot`
2. Unmount `/boot`
3. `# pacman -Sy linux linux-headers` include any other kernels here.
4. `# mkdir /boot/efi`
5. Edit `/etc/fstab` to mount the ESP at `/boot/efi`
6. `# systemctl daemon-reload`
7. Mount the ESP `# mount /dev/nvme0n1p1 /boot/efi`
8. Reinstall grub with: `# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub`
9. Generate the new grub config with: `# grub-mkconfig -o /boot/grub/grub.cfg`
