"""Development tools."""

import decman
from decman.plugins import pacman


class Dev(decman.Module):
    def __init__(self):
        super().__init__("dev")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            "gcc",
            "git",
            "github-cli",
            "nodejs",
            "uv",
            "opencode",
            "distrobox",
            "just",
        }
