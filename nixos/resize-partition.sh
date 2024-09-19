#!/usr/bin/env bash

echo -e "Resizing partition.\n"

# We cant use script mode because parted will ask about aligning the partition
echo -e "resizepart\n2\nYes\n100%\nquit" | parted /dev/mmcblk0 ---pretend-input-tty
