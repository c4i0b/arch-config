"""Systemd services & timers."""

import decman
from decman.plugins import systemd


class Services(decman.Module):
    def __init__(self):
        super().__init__("services")

    @systemd.units
    def units(self) -> set[str]:
        return {
            "bluetooth.service",
            "NetworkManager-wait-online.service",
            "NetworkManager-dispatcher.service",
            "ufw.service",
            "pacman-offline-prepare.timer",
        }
