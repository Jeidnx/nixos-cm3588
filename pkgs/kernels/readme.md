# Kernel packages

### armbian-current

This is the mainline 6.10 Kernel with some patches by armbian.

Currently doesn't work, probably because im missing
[this](https://github.com/armbian/build/blob/main/patch/kernel/archive/rockchip-rk3588-6.10/0000.patching_config.yaml#L38).

### armbian-vendor

This is armbians spin of the linux-rockchip kernel.
Boots, but no ethernet.

### friendlyarm

Thiss is the "official" cm3588 vendor kernel, used in the friendlyelec images.
Also boots, but no ethernet.
