"""
arch-config — declarative Arch Linux with decman

Main source file. Organized into modules for clarity.
Run: sudo ./decman --source ./source.py
"""

import decman

from modules.boot import Boot
from modules.network import Network
from modules.desktop import Desktop
from modules.tools import Tools
from modules.dev import Dev
from modules.sysmgmt import SysMgmt
from modules.config_files import ConfigFiles

# ── Ignored packages ──────────────────────────────────────
# Essential base system packages managed outside decman.
# These are installed during OS install and should not be touched.

decman.pacman.ignored_packages |= {
    "base",
    "linux",
    "linux-firmware",
    "sudo",
    "openssh",
    # Packages that may be installed during OS setup but aren't managed here
    "base-devel",
    "cronie",
    "grub-btrfs",
    "inotify-tools",
    "network-manager-applet",
    "plasma-meta",
    "timeshift",
    # GPU-dependent packages — managed manually (NVIDIA vs AMD vs VM)
    "steam",
    "wine",
    "winetricks",
    "faugus-launcher",
    "mesa",
    "mesa-git",
    "vulkan-intel",
    "vulkan-radeon",
    "vulkan-swrast",
    "lib32-vulkan-swrast",
    "lib32-mesa",
    "lib32-mesa-git",
}

# ── Modules ───────────────────────────────────────────────

decman.modules += [
    Boot(),
    Network(),
    Desktop(),
    Tools(),
    Dev(),
    SysMgmt(),
    ConfigFiles(),
]

# ── Execution order ───────────────────────────────────────

decman.execution_order = [
    "files",
    "pacman",
    "aur",
]
