#!/bin/bash
echo "Configuring sudo..."
echo "${ARCH_SUDO_CONF}" >> /etc/sudoers.d/foo
echo "Configuring /etc/hostname..."
echo "${ARCH_USERNAME}" >> /etc/hostname
echo "Configuring /etc/hosts..."
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	${ARCH_USERNAME}.localdomain	${ARCH_USERNAME}" >> /etc/hosts
echo "Setting root password..."
#read -s -p "Password for root user:" password
password="temp"
echo -e "$password\n$password" | passwd

