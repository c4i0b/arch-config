# arch-config — declarative Arch Linux with decman

# List available recipes
@list:
    @just --list --unsorted

# ── bootstrap ─────────────────────────────────────────────

# Bootstrap CachyOS + Chaotic-AUR repos and apply config
bootstrap:
    #!/bin/bash
    set -euo pipefail
    bash setup-repos.sh
    sudo pacman -S --noconfirm --needed python pyalpm python-requests
    printf 'y\ny\n' | sudo ./decman --source ./source.py
    sudo pacman -Scc --noconfirm

# ── decman ────────────────────────────────────────────────

# Apply config to system (requires root)
apply:
    sudo ./decman --source ./source.py

# Dry-run: print what would happen
dry-run:
    sudo ./decman --source ./source.py --dry-run

# Run decman with debug output
debug:
    sudo ./decman --source ./source.py --debug

# ── setup ─────────────────────────────────────────────────

# Bootstrap CachyOS + Chaotic-AUR repos
setup-repos:
    bash setup-repos.sh

# ── info ──────────────────────────────────────────────────

# List packages declared in config
packages:
    @PYTHONPATH=./src python -c "import decman; exec(open('source.py').read()); pkgs=set(); [pkgs.update(getattr(m,n)()) for m in decman.modules for n in dir(m) if hasattr(getattr(getattr(m,n),'__func__',getattr(m,n)),'_decman_pacman_packages')]; [print(p) for p in sorted(pkgs)]"

# Show system info
info:
    @echo "=== System ==="
    @cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION)=' || true
    @echo "Kernel: $(uname -r)"
    @echo "Arch: $(uname -m)"
    @echo "Python: $(python --version 2>&1)"

# ── validation ────────────────────────────────────────────

# Validate Python config syntax
validate:
    #!/bin/bash
    echo "Checking Python syntax..."
    python -m py_compile source.py && echo "source.py OK"
    for f in modules/*.py; do python -m py_compile "$f" && echo "$f OK"; done

# ── status ────────────────────────────────────────────────

# Full system verification — reports drift or problems
status:
    #!/bin/bash
    echo "========================================"
    echo "  arch-config — system verification"
    echo "========================================"
    PROBLEMS=0
    echo ""
    echo "> Python syntax..."
    for f in source.py modules/*.py; do python -m py_compile "$f" 2>/dev/null || { echo "  FAIL: $f"; PROBLEMS=$((PROBLEMS+1)); }; done
    echo "  OK: all modules compile"
    echo ""
    echo "> Declared packages..."
    DECLARED=$(PYTHONPATH=./src python -c "import decman; exec(open('source.py').read()); pkgs=set(); [pkgs.update(getattr(m,n)()) for m in decman.modules for n in dir(m) if hasattr(getattr(getattr(m,n),'__func__',getattr(m,n)),'_decman_pacman_packages')]; print(chr(10).join(sorted(pkgs)))" 2>/dev/null)
    TOTAL=$(echo "$DECLARED" | wc -l)
    INSTALLED=0; MISSING=""
    for pkg in $DECLARED; do pacman -Q "$pkg" >/dev/null 2>&1 && INSTALLED=$((INSTALLED+1)) || MISSING="$MISSING $pkg"; done
    echo "  $INSTALLED/$TOTAL installed"
    if [ -n "$MISSING" ]; then echo "  MISSING:$MISSING"; PROBLEMS=$((PROBLEMS+1)); else echo "  OK: all installed"; fi
    echo ""
    echo "> Config files..."
    for f in /etc/modprobe.d/snd-hda-intel.conf /etc/brave/policies/managed/policies.json; do [ -f "$f" ] && echo "  OK: $f" || { echo "  FAIL: $f"; PROBLEMS=$((PROBLEMS+1)); }; done
    echo ""
    echo "========================================"
    if [ "$PROBLEMS" -eq 0 ]; then echo "  ALL CHECKS PASSED"; else echo "  $PROBLEMS PROBLEM(S) FOUND"; fi
    echo "========================================"

# ── combined ──────────────────────────────────────────────

# Run all validation checks
check-all: validate
    @echo "All checks passed."
