# Paths that aconfmgr should NOT manage
# System state, user data, generated files, container artifacts
#
# Note: directories need /* suffix — aconfmgr converts IgnorePath to
# a find -regex that matches the FULL path. Without /*, only the
# exact path matches, not its contents.

# Virtual filesystems
IgnorePath /proc/*
IgnorePath /sys/*
IgnorePath /dev/*

# Temporary and runtime
IgnorePath /tmp/*
IgnorePath /var/tmp/*
IgnorePath /run/*

# System state (logs, caches, databases)
IgnorePath /var/*

# User data
IgnorePath /home/*
IgnorePath /root/*

# Mount points
IgnorePath /mnt/*
IgnorePath /media/*
IgnorePath /srv/*

# Boot files (specific files managed via CopyFile in 95-config.sh)
IgnorePath /boot/*
IgnorePath /efi/*

# Locally installed / distrobox integration (themes, icons, fonts from host)
IgnorePath /usr/local/*

# Generated / container-specific files
IgnorePath /etc/machine-id
IgnorePath /etc/hostname
IgnorePath /etc/resolv.conf
IgnorePath /etc/hosts

# pacman.conf (managed by setup-repos.sh, CPU-dependent repos)
IgnorePath /etc/pacman.conf
