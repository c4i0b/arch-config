# Add NoExtract for KDE Discover autostart (prevents it from being reinstalled)

DISCOVER_NOEXTRACT="etc/xdg/autostart/org.kde.discover.notifier.desktop"

add_noextract() {
    local conf="/etc/pacman.conf"

    if grep -q "^NoExtract.*${DISCOVER_NOEXTRACT}" "$conf"; then
        return
    fi

    echo ":: Adding NoExtract..."

    local tmp; tmp=$(mktemp)
    awk -v entry="NoExtract = ${DISCOVER_NOEXTRACT}" '
        /^\[options\]/ && !done {
            print
            print entry
            done = 1
            next
        }
        { print }
    ' "$conf" > "$tmp" && sudo mv "$tmp" "$conf"
}
