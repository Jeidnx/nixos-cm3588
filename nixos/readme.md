## Nixos modules

### cm3588

This is the module which provides the kernel and boot support for the cm3588. There are some options:

All the options are under the `hardware.cm3588` name.

- `kernel`: One of (armbian-current|armbian-vendor|friendlyarm). See [the kernel
  readme](/pkgs/kernels/readme.md) for more info.

- `mali.enableFirmware`: Enables the firmware for the gpu

- `mali.firmwarePackage`: If you want to overwrite the firmware package
