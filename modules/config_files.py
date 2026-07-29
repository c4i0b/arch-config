"""Configuration files managed by decman.

Only files NOT handled by archinstall or package defaults.
"""

import decman
from decman import File


class ConfigFiles(decman.Module):
    def __init__(self):
        super().__init__("config-files")

    def files(self) -> dict[str, File]:
        return {
            "/etc/modprobe.d/snd-hda-intel.conf": File(
                source_file="./files/etc/modprobe.d/snd-hda-intel.conf"
            ),
            "/etc/brave/policies/managed/policies.json": File(
                source_file="./files/etc/brave/policies/managed/policies.json"
            ),
        }
