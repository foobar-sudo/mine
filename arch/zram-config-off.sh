#!/bin/bash
ls /dev/zram* | while read line; do swapoff $line; done
