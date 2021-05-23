#!/bin/bash

swap="vm.swappiness = 100
vm.vfs_cache_pressure = 500
vm.dirty_background_ratio=1
vm.dirty_ratio=50" # force swap
sysrq="kernel.sysrq = 1"
net="net.core.netdev_max_backlog = 16384
net.core.somaxconn = 8192
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_no_metrics_save = 1
net.core.netdev_max_backlog = 5000
"
net_bbr="net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr2"
settings=("$swap" "$sysrq" "$net")
mkdir -p /etc/sysctl.d
echo "${settings[@]}" | tee -a /etc/sysctl.d/foo.conf
