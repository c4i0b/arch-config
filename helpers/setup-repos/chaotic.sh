# Chaotic-AUR: key, keyring, mirrorlist, and pacman.conf repo entry

CHAOTIC_KEY_ID="3056513887B78AEB"
CHAOTIC_MIRROR="https://cdn-mirror.chaotic.cx/chaotic-aur"

setup_chaotic() {
    echo ":: Setting up Chaotic-AUR..."

    sudo pacman-key --recv-key "$CHAOTIC_KEY_ID" --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key "$CHAOTIC_KEY_ID"

    sudo pacman -U --noconfirm \
        "${CHAOTIC_MIRROR}/chaotic-keyring.pkg.tar.zst" \
        "${CHAOTIC_MIRROR}/chaotic-mirrorlist.pkg.tar.zst"

    _chaotic_add_repo
}

_chaotic_add_repo() {
    local conf="/etc/pacman.conf"

    if grep -q '^\[chaotic-aur\]' "$conf"; then
        return
    fi

    printf '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' | sudo tee -a "$conf" > /dev/null
}
