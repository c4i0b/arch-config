#!/bin/bash
set -euo pipefail

# Bootstrap third-party repositories
# Run once before first aconfmgr apply

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

# Source helpers
source "$SCRIPT_DIR/helpers/setup-repos/cpu-detect.sh"
source "$SCRIPT_DIR/helpers/setup-repos/cachyos.sh"
source "$SCRIPT_DIR/helpers/setup-repos/chaotic.sh"
source "$SCRIPT_DIR/helpers/setup-repos/multilib.sh"
source "$SCRIPT_DIR/helpers/setup-repos/noextract.sh"
source "$SCRIPT_DIR/helpers/setup-repos/sysupgrade.sh"

# --- Run ---

CPU_LEVEL=$(detect_cpu_level)
echo ":: Detected CPU level: $CPU_LEVEL"

echo ":: Initializing pacman keyring..."
sudo pacman-key --init

setup_cachyos "$CPU_LEVEL"
setup_chaotic
enable_multilib
add_noextract

echo ":: Synchronizing package databases..."
sudo pacman -Sy

sysupgrade

echo ":: Done. Run './aconfmgr apply' next."
