# Enable multilib repository in pacman.conf

enable_multilib() {
    local conf="/etc/pacman.conf"

    if grep -q '^\[multilib\]' "$conf"; then
        return
    fi

    echo ":: Enabling multilib..."

    if grep -q '^#\[multilib\]' "$conf"; then
        sudo sed -i '/^#\[multilib\]/,/^#Include/{s/^#//}' "$conf"
    else
        printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a "$conf" > /dev/null
    fi
}
