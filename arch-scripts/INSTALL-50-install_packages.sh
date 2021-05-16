#!/bin/bash
echo "Installing packages..."
sudo -u $ARCH_USERNAME paru -S ${ARCH_SECOND_PACKAGES}
