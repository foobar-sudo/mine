#!/bin/bash
echo "Creating new udev rules..."
mkdir -p /etc/udev/rules.d/
echo 'SUBSYSTEM=="input", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", ENV{ID_INPUT_JOYSTICK}=="?*", ENV{ID_INPUT_JOYSTICK}=""
SUBSYSTEM=="input", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", KERNEL=="js[0-9]*", MODE="0000", ENV{ID_INPUT_JOYSTICK}=""' >> /etc/udev/rules.d/60-foo.rules
#ASRock LED controller

echo 'ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' >> /etc/udev/rules.d/60-foo.rules
