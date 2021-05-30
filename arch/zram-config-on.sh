#!/bin/bash
zramCount=4
compAlgorithm="zstd"
_sysMemory=
if [[ "$_sysMemory" -le 0 ]]; then _sysMemory=$(grep MemTotal /proc/meminfo | awk '{print $2}' | numfmt --from-unit=Ki --to-unit=Mi); fi
if [[ $zramCount -le 0 ]]; then echo "Invalid number of ZRAM devices."; zramCount=1; fi
echo "Memory is ${_sysMemory} MB."
echo "Disabling zswap..."
echo 0 > /sys/module/zswap/parameters/enabled
echo "Modprobe zram..."
modprobe zram num_devices=$(( ${zramCount} + 1 ))
_suffix="M"
_zramLimitPercent=$(awk -v n="${_sysMemory}" -v p="${zramCount}" 'BEGIN{print 0.85/int(p)}')
_zramLimit=$(awk -v n="${_sysMemory}" -v p="${_zramLimitPercent}" 'BEGIN{print int(n*p)}')
_zramSizePercent=$(awk -v n="${zramCount}" 'BEGIN{print (2.0/n)}')
_zramSize=$(awk -v n="${_sysMemory}" -v p="${_zramSizePercent}" 'BEGIN{print int(n*p)}')
_zramPriority=32767
_zramsIterator=$(("${zramCount}" - 1 ))
echo "Creating zram devices..."
for zramNumber in $(eval echo "{0..$_zramsIterator}"); do
echo "${compAlgorithm}" > /sys/block/zram${zramNumber}/comp_algorithm
echo  "${_zramSize}M" > /sys/block/zram${zramNumber}/disksize
echo "${_zramLimit}M" > /sys/block/zram${zramNumber}/mem_limit
mkswap --label "zram${zramNumber}" /dev/zram${zramNumber}
swapon --priority ${_zramPriority} /dev/zram${zramNumber}
echo "Created /dev/zram${zramNumber}"
done
echo "Creating /tmp..."
echo "Unmounting /tmp just in case..."
umount --force /tmp
echo "Creating zram device..."
zramNumber=${zramCount}
echo "${compAlgorithm}" > /sys/block/zram${zramNumber}/comp_algorithm
_zramSizePercent="2.0"
_zramSize=$(awk -v n="${_sysMemory}" -v p="${_zramSizePercent}" 'BEGIN{print int(n*p)}')
_zramLimitPercent="0.85"
_zramLimit=$(awk -v n="${_sysMemory}" -v p="${_zramLimitPercent}" 'BEGIN{print int(n*p)}')
echo "${_zramSize}M" > /sys/block/zram${zramNumber}/disksize
echo "${_zramLimit}M" > /sys/block/zram${zramNumber}/mem_limit
echo "Created /dev/zram${zramNumber}"
mkfs.ext4 /dev/zram4
mount -t tmpfs -o size=0,nr_inodes=0 tmpfs /tmp
mount /dev/zram${zramNumber} /tmp
chmod 1777 /tmp
echo "Created /tmp on /dev/zram${zramNumber}"
