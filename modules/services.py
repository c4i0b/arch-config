"""Systemd services that need explicit enabling."""

import decman
from decman.plugins import systemd


class Services(decman.Module):
    def __init__(self):
        super().__init__("services")

    @systemd.units
    def units(self) -> set[str]:
        return {
            "ufw.service",
            "pacman-offline-prepare.timer",
        }
