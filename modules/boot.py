"""Kernel, firmware & bootloader packages."""

import decman
from decman.plugins import pacman


class Boot(decman.Module):
    def __init__(self):
        super().__init__("boot")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            "linux-headers",
            "grub",
            "grub-hook",
            "mkinitcpio",
            "efibootmgr",
            "btrfs-progs",
            # CachyOS
            "cachyos-kernel-manager",
            "cachyos-keyring",
            "cachyos-mirrorlist",
            "cachyos-v3-mirrorlist",
            "cachyos-v4-mirrorlist",
            # Chaotic-AUR
            "chaotic-keyring",
            "chaotic-mirrorlist",
        }
