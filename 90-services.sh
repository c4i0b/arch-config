# Systemd services & timers

# bluetooth
CreateLink /etc/systemd/system/bluetooth.target.wants/bluetooth.service /usr/lib/systemd/system/bluetooth.service

# NetworkManager
CreateLink /etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service /usr/lib/systemd/system/NetworkManager-wait-online.service
CreateLink /etc/systemd/system/multi-user.target.wants/NetworkManager-dispatcher.service /usr/lib/systemd/system/NetworkManager-dispatcher.service

# ufw
CreateLink /etc/systemd/system/multi-user.target.wants/ufw.service /usr/lib/systemd/system/ufw.service

# pacman-offline
CreateLink /etc/systemd/system/timers.target.wants/pacman-offline-prepare.timer /usr/lib/systemd/system/pacman-offline-prepare.timer
