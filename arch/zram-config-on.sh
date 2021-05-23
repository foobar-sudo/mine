#!/bin/bash
# As of this moment, 4 zram devices is the only RECOMMENDED way of using this script.
zramCount=4 # >0
compAlgorithm="zstd"
#memory= # in mB (1024) (15931 - 16 GB)
memory=$(grep MemTotal /proc/meminfo | awk '{print $2}' | numfmt --from-unit=Ki --to-unit=Mi)
# systemMemory
if [[ -z "$memory" ]]; then echo "Memory variable is not set! Setting it as system's memory."; memory=$(grep MemTotal /proc/meminfo | awk '{print $2}' | numfmt --from-unit=Ki --to-unit=Mi); fi
echo "Memory is ${memory} MiB."
echo "Disabling zswap..."
echo 0 > /sys/module/zswap/parameters/enabled
echo "Modprobe zram..."
modprobe zram num_devices=${zramCount}
_suffix="M"
_memoryLimitPercent="0.2125"
_memoryLimit=$(awk -v n="${memory}" -v p="${_memoryLimitPercent}" 'BEGIN{print int(n*p)}')
_diskSizePercent="0.5"
_diskSize=$(awk -v n="${memory}" -v p="${_diskSizePercent}" 'BEGIN{print int(n*p)}')
_priority=32767
_zrams=$(("${zramCount}" - 1 ))
echo "Creating zram devices..."
for zramNumber in $(eval echo "{0..$_zrams}"); do
echo "${compAlgorithm}" > /sys/block/zram${zramNumber}/comp_algorithm
echo  "${_diskSize}" > /sys/block/zram${zramNumber}/disksize
echo "${_memoryLimit}" > /sys/block/zram${zramNumber}/mem_limit
mkswap --label "zram${zramNumber}" /dev/zram${zramNumber}
swapon --priority ${_priority} /dev/zram${zramNumber}
echo "Created /dev/zram${zramNumber}"
done
