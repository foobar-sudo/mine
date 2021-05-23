#!/bin/bash
echo "Setting up systemd-resolved..."
pacman -Qi systemd-resolvconf 1>/dev/null 2>/dev/null && echo "systemd-resolvconf is installed." || { echo "systemd-resolvconf is not installed! Installing now..."; pacman -S systemd-resolvconf; }
echo "Creating systemd-resolved directory..."
mkdir -p /etc/systemd/resolved.conf.d/
echo "Configuring systemd-resolved..."
echo "[Resolve]
DNS=9.9.9.9#dns.quad9.net
DNSSEC=allow-downgrade
DNSOverTLS=yes
ReadEtcHosts=yes" >> /etc/systemd/resolved.conf.d/foo.conf
systemctl enable systemd-resolved
echo "Configuring systemd-networkd..."
echo "[Match]
Name=en*
[Network]
DHCP=ipv4
IPForward=ipv4" >> /etc/systemd/network/foo.network
systemctl enable systemd-networkd
