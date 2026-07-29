"""System management packages."""

import decman
from decman.plugins import pacman


class SysMgmt(decman.Module):
    def __init__(self):
        super().__init__("sysmgmt")

    @pacman.packages
    def pkgs(self) -> set[str]:
        return {
            "fastfetch",
            "smartmontools",
            "power-profiles-daemon",
            "zram-generator",
            "podman",
            "podman-compose",
            "podman-docker",
            "pacman-offline",
            "paccache-hook",
            "shelly",
            "topgrade",
            "gnome-disk-utility",
            "goverlay",
            "virtualbox",
            "reflector-simple",
            "wget",
            "vim",
            "xdg-utils",
            # Python runtime for bundled decman
            "python",
            "pyalpm",
            "python-requests",
        }
