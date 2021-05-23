#!/bin/bash
echo "Configuring systemd-oomd..."
mkdir -p /etc/systemd/oomd.conf.d/
echo "[OOM]
SwapUsedLimit=95%
DefaultMemoryPressureLimit=60%
DefaultMemoryPressureDurationSec=30s" >> /etc/systemd/oomd.conf.d/foo.conf
systemctl enable systemd-oomd
