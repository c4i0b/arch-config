# CachyOS: key, keyring, mirrorlists, and pacman.conf repo entries

CACHYOS_KEY_ID="F3B607488DB35A47"
CACHYOS_MIRROR="https://mirror.cachyos.org/repo/x86_64/cachyos"

setup_cachyos() {
    local cpu_level="$1"

    echo ":: Setting up CachyOS..."

    sudo pacman-key --recv-keys "$CACHYOS_KEY_ID" --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key "$CACHYOS_KEY_ID"

    sudo pacman -U --noconfirm \
        "${CACHYOS_MIRROR}/cachyos-keyring-20240331-1-any.pkg.tar.zst" \
        "${CACHYOS_MIRROR}/cachyos-mirrorlist-27-1-any.pkg.tar.zst" \
        "${CACHYOS_MIRROR}/cachyos-v3-mirrorlist-27-1-any.pkg.tar.zst" \
        "${CACHYOS_MIRROR}/cachyos-v4-mirrorlist-27-1-any.pkg.tar.zst"

    _cachyos_set_architecture "$cpu_level"
    _cachyos_add_repos "$cpu_level"
}

# Stock pacman resolves Architecture=auto to just x86_64 (uname -m).
# CachyOS's patched pacman detects v3/v4 at runtime. Since we use
# stock pacman, we must set Architecture explicitly to accept
# v3/v4 packages from CachyOS repos.
_cachyos_set_architecture() {
    local cpu_level="$1"
    local conf="/etc/pacman.conf"

    local arch
    case "$cpu_level" in
        znver4|v4) arch="x86_64 x86_64_v3 x86_64_v4" ;;
        v3)        arch="x86_64 x86_64_v3" ;;
        *)         return ;;  # x86_64: auto is fine
    esac

    sudo sed -i "s/^Architecture = .*/Architecture = ${arch}/" "$conf"
}

_cachyos_add_repos() {
    local cpu_level="$1"
    local conf="/etc/pacman.conf"

    if grep -q '^\[cachyos' "$conf"; then
        return
    fi

    local block; block=$(mktemp)

    case "$cpu_level" in
        znver4|v4|v3)
            local variant vmirrorlist
            case "$cpu_level" in
                znver4) variant="znver4"; vmirrorlist="cachyos-v4-mirrorlist" ;;
                v4)     variant="v4";     vmirrorlist="cachyos-v4-mirrorlist" ;;
                v3)     variant="v3";     vmirrorlist="cachyos-v3-mirrorlist" ;;
            esac
            cat > "$block" << EOF
[cachyos-${variant}]
Include = /etc/pacman.d/${vmirrorlist}

[cachyos-core-${variant}]
Include = /etc/pacman.d/${vmirrorlist}

[cachyos-extra-${variant}]
Include = /etc/pacman.d/${vmirrorlist}

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist

EOF
            ;;
        x86_64)
            # Generic only (VMs without v3/v4 support)
            cat > "$block" << EOF
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist

EOF
            ;;
    esac

    local tmp; tmp=$(mktemp)
    awk -v blockfile="$block" '
        /^\[core\]/ && !done {
            while ((getline line < blockfile) > 0) print line
            done = 1
        }
        { print }
    ' "$conf" > "$tmp" && sudo mv "$tmp" "$conf"
    rm -f "$block"
}
