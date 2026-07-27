# CPU detection adapted from CachyOS official cachyos-repo.sh
# No base-devel required (uses ld-linux + /proc/cpuinfo instead of gcc)

detect_cpu_level() {
    # Returns: znver4 | v4 | v3
    local family

    # znver4/5 via /proc/cpuinfo (AMD family 25=Zen4, 26=Zen5)
    family=$(awk -F: '/^cpu family/ { gsub(/ /, "", $2); print $2; exit }' /proc/cpuinfo 2>/dev/null || echo "")
    if [ "$family" = "25" ] || [ "$family" = "26" ]; then
        echo "znver4"
        return
    fi

    # x86-64-v4 ISA via ld-linux
    if /lib/ld-linux-x86-64.so.2 --help 2>/dev/null | grep -q "x86-64-v4 (supported, searched)"; then
        echo "v4"
        return
    fi

    # Default
    echo "v3"
}
