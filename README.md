# arch-config

Declarative Arch Linux with [decman](https://github.com/kiviktnm/decman).

## Quick start

```bash
pacman -S git just
git clone https://github.com/c4i0b/arch-config
cd arch-config
just bootstrap
```

## Commands

```bash
just apply       # apply config to system
just dry-run     # print what would happen
just validate    # check Python syntax
just check-all   # run all validation
```

See `just list` for all recipes.

## System

- **OS:** Arch Linux (x86_64_v4)
- **Desktop:** KDE Plasma
- **Bootloader:** GRUB
- **GPU:** NVIDIA (main) / VM-adaptive (vm-test)
