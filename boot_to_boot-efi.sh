echo "Clearing /boot/..."
rm -rf /boot/*

echo "Unmounting /boot/..."
umount /boot

echo "Installing linux kernel and generating images..."
pacman -Sy linux

echo "Mounting /boot/efi..."
mkdir /boot/efi

echo "Editing /etc/fstab..."
sed -i 's/\/boot/\/boot\/efi/g' /etc/fstab

echo "Reloading systemctl daemons to use the updated /etc/fstab..."
systemctl daemon-reload

echo "Finding path for ESP device..."
ESP=$(awk '/\/boot/ {print substr(prev, 3); exit} {prev=$0}' /etc/fstab)

echo "Mounting ESP device..."
mount $ESP /boot/efi

echo "Installing grub..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

echo "Creating grub config..."
grub-mkconfig -o /boot/grub/grub.cfg
