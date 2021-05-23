#!/bin/bash
echo "Preparing ZRAM..."
#mkdir -p /etc/modprobe.d/
systemctl stop system-udisks2\x2dzram\x2dsetup.slice
echo "Downloading ZRAM services..."
mkdir -p /etc/systemd/system
curl https://raw.githubusercontent.com/foobar-sudo/mine/main/arch/zram-config-off.sh | tee -a /usr/local/bin/zram-config-off
curl https://raw.githubusercontent.com/foobar-sudo/mine/main/arch/zram-config-on.sh | tee -a /usr/local/bin/zram-config-on
chmod +x /usr/local/bin/zram-config-on
chmod +x /usr/local/bin/zram-config-off
curl https://raw.githubusercontent.com/foobar-sudo/mine/main/arch/zram-config.service | tee -a /etc/systemd/system/zram-config.service
echo "Enabling ZRAM services..."
systemctl enable zram-config
