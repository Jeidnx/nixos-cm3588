# Nixos on the CM3588

## This is currently very WIP

This flake aims to provide hardware support for the CM3588.

## Howto

1.  Build EDK2 with support for the cm3588 and flash it on an sd card.

There will be a flake output to build the image, but i haven't gotten around
to it yet. We flash the image on an sdcard because the chip defaults to booting
from the sdcard, if one is inserted. This leaves us all the room on the emmc to
install the system.

2.  Make sure EDK2 boots and switch from acpi to devicetree mode in the settings.

3.  Build the emmc image. There are two variants, `.#efi-img` and
    `.#efi-img-swap`. The swap variant includes a placeholder for a swap partition
    (33% of the root partition, min 4 and max 10GB). If you can i would suggest
    placing the swap partition on a connected nvme / sata ssd, since it will be
    faster and have better endurance than the onboard emmc.

4.  Flash the efi image to the emmc. You can use the `flash.sh` script for this purpose.

5.  Reset the board and wait for it to load into NixOS. The default credentials
    are `admin:friendly`, and ssh is enabled.

6.  Resize the root partition to take up the remaining space on the emmc. You can
    use parted, or the `resize-part` script in the home directory for this.

7.  From here install NixOS as you would normally. Make sure to install the
    bootloader again and include the `.#nixosModules.cm3588-hardware` module
    from this flake.
