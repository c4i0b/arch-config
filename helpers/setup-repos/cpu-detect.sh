# CPU detection adapted from CachyOS official cachyos-repo.sh
# No base-devel required (uses ld-linux + /proc/cpuinfo instead of gcc)

detect_cpu_level() {
    # Returns: znver4 | v4 | v3
    #
    # Order matters: check actual ISA support (ld-linux) FIRST,
    # then refine with CPU model (/proc/cpuinfo).
    # This prevents false znver4 detection on VMs with host CPU
    # passthrough where /proc/cpuinfo reports the host family but
    # the VM doesn't actually support x86-64-v4 instructions.

    # x86-64-v4 ISA via ld-linux (runtime test, not feature flags)
    if /lib/ld-linux-x86-64.so.2 --help 2>/dev/null | grep -q "x86-64-v4 (supported, searched)"; then
        # v4 is supported — check for AMD Zen 4/5 for znver4-optimized repos
        local family
        family=$(awk -F: '/^cpu family/ { gsub(/ /, "", $2); print $2; exit }' /proc/cpuinfo 2>/dev/null || echo "")
        if [ "$family" = "25" ] || [ "$family" = "26" ]; then
            echo "znver4"
        else
            echo "v4"
        fi
        return
    fi

    # Default
    echo "v3"
}
