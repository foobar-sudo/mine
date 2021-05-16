#!/bin/bash
cd /tmp
git clone "${ARCH_PARU_GIT}"
cd "${ARCH_PARU_DIR}"
chown -R ${ARCH_USERNAME} .
sudo -u ${ARCH_USERNAME} makepkg -fsri
