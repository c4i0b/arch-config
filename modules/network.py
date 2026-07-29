"""Networking & firewall."""

import decman
from decman.plugins import pacman


class Network(decman.Module):
    def __init__(self):
        super().__init__("network")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            "ufw",
            "networkmanager",
            "wpa_supplicant",
        }
