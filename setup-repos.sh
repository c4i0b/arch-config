#!/bin/bash
set -euo pipefail

# Bootstrap third-party repositories
# Run once before first aconfmgr apply
# Order: CachyOS first, then Chaotic-AUR

BOOTSTRAP_CONF=$(mktemp /tmp/pacman-bootstrap-XXXXXX.conf)
trap 'rm -f "$BOOTSTRAP_CONF"' EXIT

# --- Init keyring (needed on fresh installs / containers) ---

echo ":: Initializing pacman keyring..."
sudo pacman-key --init

# --- CachyOS repos ---

echo ":: Importing CachyOS key..."
sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47

cat > "$BOOTSTRAP_CONF" << 'EOF'
[options]
Architecture = auto

[cachyos]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch/$repo

[cachyos-core]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch/$repo

[cachyos-extra]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch/$repo

[cachyos-znver4]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch_v4/$repo

[cachyos-core-znver4]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch_v4/$repo

[cachyos-extra-znver4]
SigLevel = Optional TrustAll
Server = https://mirror.cachyos.org/repo/$arch_v4/$repo
EOF

echo ":: Installing CachyOS keyring and mirrorlists..."
sudo pacman -Sy --noconfirm --config "$BOOTSTRAP_CONF" \
    cachyos-keyring \
    cachyos-mirrorlist \
    cachyos-v3-mirrorlist \
    cachyos-v4-mirrorlist

# --- Chaotic-AUR ---

echo ":: Importing Chaotic-AUR key..."
sudo pacman-key --recv-keys 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

echo ":: Installing Chaotic-AUR keyring and mirrorlist..."
sudo pacman -U --noconfirm \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo ":: Done. Run './aconfmgr apply' next."
