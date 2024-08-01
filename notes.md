`timeshift-pre-pacman.hook` goes in `/etc/pacman.d/hooks/`

Enable `cronie`

Comment out sudoers file option and uncomment `wheel`

`echo "127.0.0.1 $(hostname)" | tee -a /etc/hosts` *add `sudo` in front of `tee` if not run as root*

After installing, the default ESP mount point will be `/boot`. We don't want that, because BTRFS will not see the kernel images and that causes problems later. Here's how to move the ESP to `/boot/efi` and store your kernel images in `/boot`

1. Delete everything in `/boot`
2. Unmount `/boot`
3. `# pacman -Sy linux` include any other kernels here.
4. Install either `amd-ucode` or `intel-ucode`.
5. `# mkdir /boot/efi`
6. Edit `/etc/fstab` to mount the ESP at `/boot/efi`
7. `# systemctl daemon-reload`
8. Mount the ESP `# mount /dev/nvme0n1p1 /boot/efi`
9. Reinstall grub with: `# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub`
10. Generate the new grub config with: `# grub-mkconfig -o /boot/grub/grub.cfg`
