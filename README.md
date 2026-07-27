# arch-config

Declarative Arch Linux with [aconfmgr](https://github.com/CyberShadow/aconfmgr).

## Quick start

```bash
pacman -S git just
git clone https://github.com/c4i0b/arch-config.git
cd arch-config
just bootstrap
```

## Commands

```bash
just apply       # apply config to system
just check       # check for drift
just save        # save current system state
just check-all   # validate + lint + format check
```

See `just list` for all recipes.

## System

- **OS:** Arch Linux (x86_64_v4)
- **Desktop:** KDE Plasma
- **Bootloader:** GRUB
- **GPU:** NVIDIA
