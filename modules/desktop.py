"""KDE Plasma desktop, input method, Plymouth."""

import decman
from decman.plugins import pacman


class Desktop(decman.Module):
    def __init__(self):
        super().__init__("desktop")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            # KDE
            "dolphin",
            "konsole",
            "kwalletmanager",
            "kio-admin",
            # Plymouth
            "plymouth",
            # Input method
            "fcitx5",
            "fcitx5-configtool",
            "fcitx5-gtk",
            "fcitx5-qt",
        }
