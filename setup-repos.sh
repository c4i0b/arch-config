#!/bin/bash
set -euo pipefail

# Bootstrap third-party repositories
# Run once before first aconfmgr apply
# Order: CachyOS first, then Chaotic-AUR
#
# CPU detection adapted from CachyOS official cachyos-repo.sh:
#   - ISA level (v3/v4) via ld-linux (no base-devel needed)
#   - znver4/5 via /proc/cpuinfo (replaces gcc check, no base-devel needed)

# --- CPU detection ---

detect_cpu_level() {
    # Returns: znver4 | v4 | v3
    local family

    # Check znver4/5 via /proc/cpuinfo (AMD family 25=Zen4, 26=Zen5)
    family=$(awk -F: '/^cpu family/ { gsub(/ /, "", $2); print $2; exit }' /proc/cpuinfo 2>/dev/null || echo "")
    if [ "$family" = "25" ] || [ "$family" = "26" ]; then
        echo "znver4"
        return
    fi

    # Check x86-64-v4 ISA via ld-linux
    if /lib/ld-linux-x86-64.so.2 --help 2>/dev/null | grep -q "x86-64-v4 (supported, searched)"; then
        echo "v4"
        return
    fi

    # Default to v3
    echo "v3"
}

CPU_LEVEL=$(detect_cpu_level)
echo ":: Detected CPU level: $CPU_LEVEL"

# --- Init keyring (needed on fresh installs / containers) ---

echo ":: Initializing pacman keyring..."
sudo pacman-key --init

# --- CachyOS repos ---

echo ":: Importing CachyOS key..."
sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47

echo ":: Installing CachyOS keyring and mirrorlists..."
CACHYOS_MIRROR="https://mirror.cachyos.org/repo/x86_64/cachyos"
sudo pacman -U --noconfirm \
    "${CACHYOS_MIRROR}/cachyos-keyring-20240331-1-any.pkg.tar.zst" \
    "${CACHYOS_MIRROR}/cachyos-mirrorlist-27-1-any.pkg.tar.zst" \
    "${CACHYOS_MIRROR}/cachyos-v3-mirrorlist-27-1-any.pkg.tar.zst" \
    "${CACHYOS_MIRROR}/cachyos-v4-mirrorlist-27-1-any.pkg.tar.zst"

# --- Chaotic-AUR ---

echo ":: Importing Chaotic-AUR key..."
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

echo ":: Installing Chaotic-AUR keyring and mirrorlist..."
CHAOTIC_MIRROR="https://cdn-mirror.chaotic.cx/chaotic-aur"
sudo pacman -U --noconfirm \
    "${CHAOTIC_MIRROR}/chaotic-keyring.pkg.tar.zst" \
    "${CHAOTIC_MIRROR}/chaotic-mirrorlist.pkg.tar.zst"

echo ":: Done. Detected CPU level: $CPU_LEVEL. Run './aconfmgr apply' next."
