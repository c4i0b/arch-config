# Configuration files
# Owner: caio:caio (where applicable)

CopyFile /etc/default/grub
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/plymouth/plymouthd.conf
CopyFile /etc/modprobe.d/snd-hda-intel.conf
CopyFile /etc/pacman.conf
CopyFile /etc/brave/policies/managed/policies.json

# sudoers needs strict permissions
CopyFile /etc/sudoers.d/00_caio 440 root root

# GRUB EFI stub
CopyFile /boot/efi/grub/grub.cfg
