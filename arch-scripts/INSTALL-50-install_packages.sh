#!/bin/bash
echo "Refreshing databases just in case..."
yes "" | sudo -u $ARCH_USERNAME paru -Syyu
echo "Installing packages..."
yes "" | sudo -u $ARCH_USERNAME paru -Syyu --skipreview  ${ARCH_SECOND_PACKAGES}
