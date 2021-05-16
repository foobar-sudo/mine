#!/bin/bash
echo "Creating user ${ARCH_USERNAME}..."
useradd -m -G ${ARCH_USERGROUPS} -s ${ARCH_USERSHELL} ${ARCH_USERNAME}
echo "Setting password for user ${ARCH_USERNAME}..."
passwd ${ARCH_USERNAME}
