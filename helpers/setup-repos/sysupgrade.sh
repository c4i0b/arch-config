# Full system upgrade allowing downgrades
# Needed after switching repos (e.g. vanilla Arch → CachyOS) to align package versions

sysupgrade() {
    echo ":: Performing full system upgrade (downgrades allowed)..."
    sudo pacman -Syyuu --noconfirm
}
