# arch-config

Declarative system configuration for Arch Linux using [aconfmgr](https://github.com/CyberShadow/aconfmgr).

Bundles aconfmgr so the repo is self-contained — no external dependencies beyond `bash` and `pacman`.

## Structure

```
├── aconfmgr          # aconfmgr script (bundled)
├── src/              # aconfmgr source (bundled)
├── setup-repos.sh    # Bootstrap CachyOS + Chaotic-AUR repos
├── *.sh              # aconfmgr config (numbered by category)
└── files/            # Config file copies
```

## Fresh install

Use after [archinstall](https://archlinux.org/download/). Reboot into the new system, then chroot (`arch-chroot /mnt`) or log in as root.

```bash
# As root, install git
pacman -S --noconfirm git

# Clone as your user
git clone https://github.com/c4i0b/arch-config.git ~/.config/aconfmgr
cd ~/.config/aconfmgr

# Bootstrap CachyOS + Chaotic-AUR repos (required before first apply)
bash setup-repos.sh

# Apply
./aconfmgr apply
```

## Maintenance

```bash
# Check for drift (what would change)
./aconfmgr check

# Save current system state to config
./aconfmgr save

# Apply config to system
./aconfmgr apply
```

## System

- **OS:** Arch Linux (x86_64_v4)
- **Desktop:** KDE Plasma
- **Bootloader:** GRUB
- **GPU:** NVIDIA

## Updating aconfmgr

To update the bundled aconfmgr:

```bash
# Copy new files from upstream
cp /path/to/aconfmgr/aconfmgr ./aconfmgr
cp -r /path/to/aconfmgr/src/ ./src/
```

## License

aconfmgr is licensed under MIT. Config files are system-specific.
