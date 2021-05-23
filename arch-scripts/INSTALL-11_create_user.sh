#!/bin/bash
echo "Creating user ${ARCH_USERNAME}..."
useradd -m -G ${ARCH_USERGROUPS} -s ${ARCH_USERSHELL} ${ARCH_USERNAME}
echo "Setting password for user ${ARCH_USERNAME}..."
password="temp"
#read -s -p "Password for user ${ARCH_USERNAME}:" password
echo -e "$password\n$password" | passwd ${ARCH_USERNAME}
mkdir -p /home/${ARCH_USERNAME}
chown -R ${ARCH_USERNAME} /home/${ARCH_USERNAME}
