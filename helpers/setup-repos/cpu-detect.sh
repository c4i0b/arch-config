# CPU detection adapted from CachyOS official cachyos-repo.sh
# No base-devel required (uses ld-linux + /proc/cpuinfo instead of gcc)

detect_cpu_level() {
    # Returns: znver4 | v4 | v3 | x86_64
    #
    # ld-linux runtime ISA check is the gate for each level.
    # /proc/cpuinfo only refines v4 → znver4 (never overrides ISA check).
    # This prevents false detection on VMs with host CPU passthrough.

    local ld_help
    ld_help=$(/lib/ld-linux-x86-64.so.2 --help 2>/dev/null || true)

    # x86-64-v4
    if echo "$ld_help" | grep -q "x86-64-v4 (supported, searched)"; then
        local family
        family=$(awk -F: '/^cpu family/ { gsub(/ /, "", $2); print $2; exit }' /proc/cpuinfo 2>/dev/null || echo "")
        if [ "$family" = "25" ] || [ "$family" = "26" ]; then
            echo "znver4"
        else
            echo "v4"
        fi
        return
    fi

    # x86-64-v3
    if echo "$ld_help" | grep -q "x86-64-v3 (supported, searched)"; then
        echo "v3"
        return
    fi

    # Plain x86-64 (generic repos only)
    echo "x86_64"
}
