"""Configuration files (CopyFile equivalents).

Files live in ./files/ and are deployed to the system.
decman only manages declared files — no stray file scanning.
"""

import decman
from decman import File
from decman.plugins import pacman


class ConfigFiles(decman.Module):
    def __init__(self):
        super().__init__("config-files")

    def files(self) -> dict[str, File]:
        return {
            "/etc/default/grub": File(source_file="./files/etc/default/grub"),
            "/etc/mkinitcpio.conf": File(source_file="./files/etc/mkinitcpio.conf"),
            "/etc/plymouth/plymouthd.conf": File(
                source_file="./files/etc/plymouth/plymouthd.conf"
            ),
            "/etc/modprobe.d/snd-hda-intel.conf": File(
                source_file="./files/etc/modprobe.d/snd-hda-intel.conf"
            ),
            "/etc/brave/policies/managed/policies.json": File(
                source_file="./files/etc/brave/policies/managed/policies.json"
            ),
            "/etc/sudoers.d/00_caio": File(
                source_file="./files/etc/sudoers.d/00_caio",
                permissions=0o440,
            ),
        }
