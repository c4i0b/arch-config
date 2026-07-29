"""Terminal tools & fonts."""

import decman
from decman.plugins import pacman


class Tools(decman.Module):
    def __init__(self):
        super().__init__("tools")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            # CLI tools
            "bat",
            "btop",
            "eza",
            "fd",
            "fzf",
            "gdu",
            "htop",
            "lazygit",
            "nano",
            "tealdeer",
            "television",
            "superfile",
            "taskwarrior-tui",
            "fish",
            "fisher",
            # Fonts
            "noto-fonts",
            "noto-fonts-cjk",
            "noto-fonts-emoji",
            "ttf-dejavu",
            "ttf-liberation",
        }
