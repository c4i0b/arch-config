# arch-config — declarative Arch Linux with aconfmgr

# List available recipes
@list:
    @just --list --unsorted

# ── bootstrap ─────────────────────────────────────────────

# Bootstrap CachyOS + Chaotic-AUR repos and apply config
bootstrap:
    #!/bin/bash
    set -euo pipefail
    bash setup-repos.sh
    sudo ./aconfmgr apply

# ── aconfmgr ──────────────────────────────────────────────

# Apply config to system (requires root)
apply:
    sudo ./aconfmgr apply

# Check for drift against running system
check:
    sudo ./aconfmgr check

# Save current system state to config
save:
    sudo ./aconfmgr save

# ── setup ─────────────────────────────────────────────────

# Bootstrap CachyOS + Chaotic-AUR repos
setup-repos:
    bash setup-repos.sh

# ── info ──────────────────────────────────────────────────

# List packages declared in config
packages:
    @grep -h '^AddPackage ' *.sh | sed 's/AddPackage //' | sort

# List files declared in config
config-files:
    @grep -h '^CopyFile ' *.sh | sed 's/CopyFile //' | awk '{print $1}' | sort

# Show system info (OS, kernel, desktop)
info:
    @echo "=== System ==="
    @cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION)=' || true
    @echo "Kernel: $(uname -r)"
    @echo "Arch: $(uname -m)"
    @echo ""
    @echo "=== Config packages ==="
    @just packages | wc -l | xargs -I{} echo "{} packages declared"
    @echo ""
    @echo "=== Config files ==="
    @just config-files | wc -l | xargs -I{} echo "{} config files declared"

# ── validation ────────────────────────────────────────────

# Lint all shell scripts with shellcheck
lint:
    @command -v shellcheck >/dev/null 2>&1 || { echo "shellcheck not found, install with: pacman -S shellcheck"; exit 1; }
    shellcheck -x -s bash *.sh

# Format shell scripts with shfmt
fmt:
    @command -v shfmt >/dev/null 2>&1 || { echo "shfmt not found, install with: pacman -S shfmt"; exit 1; }
    shfmt -w -i 4 -bn -ci -sr *.sh

# Check formatting without modifying (for CI)
fmt-check:
    @command -v shfmt >/dev/null 2>&1 || { echo "shfmt not found, install with: pacman -S shfmt"; exit 1; }
    shfmt -d -i 4 -bn -ci -sr *.sh

# Validate aconfmgr config files parse without errors
validate:
    @echo "Checking shell syntax..."
    @for f in *.sh; do bash -n "$f" || exit 1; done
    @echo "All config files have valid syntax."

# ── combined ──────────────────────────────────────────────

# Run all validation checks
check-all: validate lint fmt-check
    @echo "All checks passed."
