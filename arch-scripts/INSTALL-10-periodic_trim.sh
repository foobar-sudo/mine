#!/bin/bash
echo "Enabling periodic fstrim timer..."
systemctl enable fstrim.timer
